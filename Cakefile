{spawn, exec} = require 'child_process'


task 'csbuild', 'start watching coffeescript files', ->
  cof = spawn "coffee", ["--watch", "-o", "resources/public/js", "src-cs"]
  cof.stdout.pipe process.stdout
  cof.stderr.pipe process.stderr


task 'dev', 'start server in dev mode', ->
  s = spawn "lein ring server"
  s.stdout.pipe process.stdout
  s.stderr.pipe process.stderr
