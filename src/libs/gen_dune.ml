let mk_prettify_rule ~location ~path f =
  Printf.printf
    {|
(rule
  (alias fmt)
  (deps
   %s
   %s/../tooling/test-prettier
   %s/../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to %s.prettier
       (chdir %s/../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/%s/%s)))
      (diff %s %s.prettier))))
|}
    f location location f location path f f f

let mk_tree_sitter_rule ~location ~path f =
  Printf.printf
    {|
(rule
  (alias tree-sitter-parse)
  (deps
   %s
   (source_tree %s/../tooling/tree-sitter-liquidsoap)
   %s/../tooling/test-tree-sitter
 )
  (action
    (chdir %s/../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/%s/%s)))))
|}
    f location location location path f

let () =
  let location = Sys.argv.(1) in
  let path = Sys.argv.(2) in
  let liq_files =
    List.sort compare
      (List.filter
         (fun f -> Filename.extension f = ".liq")
         (Build_tools.read_files ~location path))
  in
  List.iter (mk_prettify_rule ~location ~path) liq_files;
  List.iter (mk_tree_sitter_rule ~location ~path) liq_files
