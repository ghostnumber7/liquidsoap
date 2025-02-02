
(rule
  (alias fmt)
  (deps
   audio.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to audio.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/audio.liq)))
      (diff audio.liq audio.liq.prettier))))

(rule
  (alias fmt)
  (deps
   deprecations.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to deprecations.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/deprecations.liq)))
      (diff deprecations.liq deprecations.liq.prettier))))

(rule
  (alias fmt)
  (deps
   externals.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to externals.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/externals.liq)))
      (diff externals.liq externals.liq.prettier))))

(rule
  (alias fmt)
  (deps
   file.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to file.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/file.liq)))
      (diff file.liq file.liq.prettier))))

(rule
  (alias fmt)
  (deps
   gstreamer.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to gstreamer.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/gstreamer.liq)))
      (diff gstreamer.liq gstreamer.liq.prettier))))

(rule
  (alias fmt)
  (deps
   http.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to http.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/http.liq)))
      (diff http.liq http.liq.prettier))))

(rule
  (alias fmt)
  (deps
   interactive.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to interactive.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/interactive.liq)))
      (diff interactive.liq interactive.liq.prettier))))

(rule
  (alias fmt)
  (deps
   lastfm.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to lastfm.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/lastfm.liq)))
      (diff lastfm.liq lastfm.liq.prettier))))

(rule
  (alias fmt)
  (deps
   native.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to native.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/native.liq)))
      (diff native.liq native.liq.prettier))))

(rule
  (alias fmt)
  (deps
   server.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to server.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/server.liq)))
      (diff server.liq server.liq.prettier))))

(rule
  (alias fmt)
  (deps
   source.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to source.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/source.liq)))
      (diff source.liq source.liq.prettier))))

(rule
  (alias fmt)
  (deps
   telnet.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to telnet.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/telnet.liq)))
      (diff telnet.liq telnet.liq.prettier))))

(rule
  (alias fmt)
  (deps
   visualization.liq
   ../../tooling/test-prettier
   ../../tooling/prettier-plugin-liquidsoap/dist/liquidsoap.js
 )
  (action
    (progn
      (with-stdout-to visualization.liq.prettier
       (chdir ../../tooling/test-prettier
         (run pnpm prettier --config ./config.json ../../libs/extra/visualization.liq)))
      (diff visualization.liq visualization.liq.prettier))))

(rule
  (alias tree-sitter-parse)
  (deps
   audio.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/audio.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   deprecations.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/deprecations.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   externals.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/externals.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   file.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/file.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   gstreamer.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/gstreamer.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   http.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/http.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   interactive.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/interactive.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   lastfm.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/lastfm.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   native.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/native.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   server.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/server.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   source.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/source.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   telnet.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/telnet.liq)))))

(rule
  (alias tree-sitter-parse)
  (deps
   visualization.liq
   (source_tree ../../tooling/tree-sitter-liquidsoap)
   ../../tooling/test-tree-sitter
 )
  (action
    (chdir ../../tooling/test-tree-sitter/tree-sitter-liquidsoap
     (ignore-stdout
      (run npm exec tree-sitter -- parse ../../../libs/extra/visualization.liq)))))
