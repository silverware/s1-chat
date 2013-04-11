{spawn, exec} = require 'child_process'

task 'csbuild', 'start watching coffeescript files', ->
  cof = spawn "coffee", ["--watch", "-o", "resources/public/js", "src-cs"]
  cof.stdout.pipe process.stdout
  cof.stderr.pipe process.stderr
