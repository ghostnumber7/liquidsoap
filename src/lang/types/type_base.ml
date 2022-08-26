(*****************************************************************************

  Liquidsoap, a programmable audio stream generator.
  Copyright 2003-2022 Savonet team

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details, fully stated in the COPYING
  file at the root of the liquidsoap distribution.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

 *****************************************************************************)

(** Show debugging information. *)
let debug = ref (Sys.getenv_opt "LIQUIDSOAP_DEBUG_LANG" <> None)

(** Show variables levels. *)
let debug_levels = ref false

let debug_variance = ref false

(* Type information comes attached to the AST from the parsing,
 * with appropriate sharing of the type variables. Then the type inference
 * performs in-place unification.
 *
 * In order to report precise type error messages, we put very dense
 * parsing location information in the type. Every layer of it can have
 * a location. Destructive unification introduces links in such a way
 * that the old location is still accessible.
 *
 * The level annotation represents the number of abstractions which surround
 * the type in the AST -- function arguments and let-in definitions.
 * It is used to safely generalize types.
 *
 * Finally, constraints can be attached to existential (unknown, '_a)
 * and universal ('a) type variables. *)

(** {2 Types} *)

type variance = Covariant | Contravariant | Invariant

type t = { pos : Pos.Option.t; descr : descr }

(** Constraint on the types a type variable can be substituted with. *)
and constr_t = ..

and constr = < t : constr_t ; descr : string ; satisfied : t -> unit >

(** Constraints on a type variable. *)
and constraints = constr list

(** A type constructor applied to arguments (e.g. source). *)
and constructed = { constructor : string; params : (variance * t) list }

(** A method. *)
and meth = {
  meth : string;  (** name of the method *)
  scheme : scheme;  (** type sheme *)
  doc : string;  (** documentation *)
  json_name : string option;  (** name when represented as JSON *)
}

and repr_t = { t : t; json_repr : [ `Tuple | `Object ] }

and descr = ..

(** Contents of a variable. *)
and invar =
  | Free of var  (** the variable is free *)
  | Link of variance * t  (** the variable has bee substituted *)

and var = { name : int; mutable level : int; mutable constraints : constraints }

(** A type scheme (i.e. a type with universally quantified variables). *)
and scheme = var list * t

(** Type constraints *)

type constr_t += Num | Ord

(** Sets of type descriptions. *)
module DS = Set.Make (struct
  type t = string * constraints

  let compare = compare
end)

let string_of_constr c = c#descr

(** Substitutions. *)
module Subst = struct
  module M = Map.Make (struct
    type t = var

    (* We can compare variables with their indices. *)
    let compare (v : var) (v' : var) = compare v.name v'.name
  end)

  type subst = t M.t
  type t = subst

  let of_list l : t = M.of_seq (List.to_seq l)

  (** Retrieve the value of a variable. *)
  let value (s : t) (i : var) = M.find i s

  (* let filter f (s : t) = M.filter (fun i t -> f i t) s *)

  (** Whether we have the identity substitution. *)
  let is_identity (s : t) = M.is_empty s
end

module R = struct
  type t =
    [ `Constr of string * (variance * t) list
    | `List of t * [ `Object | `Tuple ]
    | `Tuple of t list
    | `Nullable of t
    | `Meth of
      string * (var list * t) * string option * t
      (* label, type scheme, JSON name, base type *)
    | `Arrow of (bool * string * t) list * t
    | `Getter of t
    | `EVar of var (* existential variable *)
    | `UVar of var (* universal variable *)
    | `Ellipsis (* omitted sub-term *)
    | `Range_Ellipsis (* omitted sub-terms (in a list, e.g. list of args) *)
    | `Debug of
      string * t * string
      (* add annotations before / after, mostly used for debugging *) ]

  and var = string * constraints
end

type custom = ..

type custom_handler = {
  typ : custom;
  copy_with : (t -> t) -> custom -> custom;
  occur_check : (var -> t -> unit) -> var -> custom -> unit;
  filter_vars : (var list -> t -> var list) -> var list -> custom -> var list;
  repr : (var list -> t -> R.t) -> var list -> custom -> R.t;
  satisfies_constraint : custom -> constr -> unit;
  subtype : (t -> t -> unit) -> custom -> custom -> unit;
  sup : (t -> t -> t) -> custom -> custom -> custom;
  to_string : custom -> string;
}

type descr +=
  | Custom of custom_handler
  | Constr of constructed
  | Getter of t
  | List of repr_t
  | Tuple of t list
  | Nullable of t
  | Meth of meth * t
  | Arrow of (bool * string * t) list * t
  | Var of invar ref

exception NotImplemented
exception Exists of Pos.Option.t * string
exception Unsatisfied_constraint

let unit = Tuple []

(** Operations on variables. *)
module Var = struct
  type t = var

  (** Compare two variables for equality. This comparison should always be used
      to compare variables (as opposed to =). *)
  let eq v v' = v.name = v'.name

  let compare v v' = compare v.name v'.name
end

(** Sets of variables. *)
module Vars = struct
  include Set.Make (Var)

  let add_list l v = add_seq (List.to_seq l) v
end

(** Create a type from its value. *)
let make ?pos d = { pos; descr = d }

(** Dereferencing gives you the meaning of a term, going through links created
    by instantiations. One should (almost) never work on a non-dereferenced
    type. *)
let rec deref t =
  match t.descr with Var { contents = Link (_, t) } -> deref t | _ -> t

(** Remove methods. This function also removes links. *)
let rec demeth t =
  let t = deref t in
  match t.descr with Meth (_, t) -> demeth t | _ -> t

(** Put the methods of the first type around the second type. *)
let rec remeth t u =
  let t = deref t in
  match t.descr with
    | Meth (m, t) -> { t with descr = Meth (m, remeth t u) }
    | _ -> u

(** Type of a method in a type. *)
let rec invoke t l =
  match (deref t).descr with
    | Meth (m, _) when m.meth = l -> m.scheme
    | Meth (_, t) -> invoke t l
    | _ -> raise Not_found

(** Do we have a method with given label? *)
let has_meth t l =
  try
    ignore (invoke t l);
    true
  with Not_found -> false

(** Type of a submethod in a type. *)
let rec invokes t = function
  | l :: ll ->
      let g, t = invoke t l in
      if ll = [] then (g, t) else invokes t ll
  | [] -> ([], t)

(** Add a method to a type. *)
let meth ?pos ?json_name meth scheme ?(doc = "") t =
  make ?pos (Meth ({ meth; scheme; doc; json_name }, t))

(** Add a submethod to a type. *)
let rec meths ?pos l v t =
  match l with
    | [] -> assert false
    | [l] -> meth ?pos l v t
    | l :: ll ->
        let g, tl = invoke t l in
        let v = meths ?pos ll v tl in
        meth ?pos l (g, v) t

(** Split the methods from the type. *)
let split_meths t =
  let rec aux hide t =
    let t = deref t in
    match t.descr with
      | Meth (m, t) ->
          let meth, t = aux (m.meth :: hide) t in
          let meth = if List.mem m.meth hide then meth else m :: meth in
          (meth, t)
      | _ -> ([], t)
  in
  aux [] t

(** Create a fresh variable. *)
let var =
  let name =
    let c = ref (-1) in
    fun () ->
      incr c;
      !c
  in
  let f ?(constraints = []) ?(level = max_int) ?pos () =
    let name = name () in
    make ?pos (Var (ref (Free { name; level; constraints })))
  in
  f

let to_string_fun =
  ref (fun ?(generalized : var list option) _ ->
      ignore generalized;
      failwith "Type.to_string not defined yet")

(** String representation of a type. *)
let to_string ?generalized (t : t) : string = !to_string_fun ?generalized t

let is_fun t = match (demeth t).descr with Arrow _ -> true | _ -> false

let is_source t =
  match (demeth t).descr with
    | Constr { constructor = "source"; _ } -> true
    | _ -> false

let custom_types : (string, custom_handler) Hashtbl.t = Hashtbl.create 10

let register_custom_type ?pos name custom =
  if Hashtbl.mem custom_types name then raise (Exists (pos, name));
  Hashtbl.add custom_types name custom

let find_custom_type_opt = Hashtbl.find_opt custom_types
