let () =
  let location = Sys.getcwd () in
  let dirname = Filename.basename location in
  let tests =
    List.filter
      (fun f -> Filename.extension f = ".liq")
      (Build_tools.read_files ~location "")
  in
  List.iter
    (fun test ->
      Printf.printf
        {|
(rule
  (alias tree-sitter-parse)
  (deps
   %s
   ../../src/tooling/test-tree-sitter
 )
  (action
    (chdir ../../src/tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../../tests/%s/%s)))))

(rule
  (alias fmt)
  (deps %s ../../src/tooling/test-prettier ../../src/tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js)
  (action
    (progn
      (with-stdout-to %s.prettier
       (chdir ../../src/tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../../tests/%s/%s)))
      (diff %s %s.prettier))))

(rule
 (alias citest)
 (package liquidsoap)
 (deps
  %s
  ../../src/bin/liquidsoap.exe
  (package liquidsoap)
  (:stdlib ../../src/libs/stdlib.liq)
  (:test_liq ../test.liq)
  (:run_test ../run_test.exe))
 (action (run %%{run_test} %s liquidsoap %%{test_liq} %s)))
  |}
        test dirname test test test dirname test test test test test test)
    tests;

  let output_tests =
    List.filter
      (fun f -> Filename.extension f = ".output")
      (Array.to_list (Sys.readdir location))
  in
  List.iter
    (fun test ->
      Printf.printf
        {|
(rule
 (alias citest)
 (package liquidsoap)
 (deps
  %s
  (:check_output ../check_output.exe)
  (:run_test ../run_test.exe))
 (action (run %%{run_test} %s %%{check_output})))
  |}
        test test)
    output_tests
