{exec} = require 'child_process'
fs = require 'fs'

readDir = (src) ->
  allFiles = []

  if src.match /\/\./g
    return allFiles

  files = fs.readdirSync(src)
  for file in files
    if file.match(/\.less$/) or file.match(/\.coffee$/)
      allFiles.push src + "/" + file
    else
      allFiles = allFiles.concat readDir(src + "/" + file)
  allFiles

watch = (folder, onChange) ->
    console.log "Watching for changes in #{folder}"
    allFiles = readDir folder
    for file in allFiles then do (file) ->
        fs.watchFile file, {persistent: true}, (curr, prev) ->
          console.log "change in file"
          onChange()

###
task 'build-cs', 'start watching coffeescript files', ->
  child = exec 'coffee --watch -o resources/public/js src-cs', (err, stdout, stderr) ->
    throw err if err
  child.stdout.pipe process.stdout
###

task 'build-less', 'start watching coffeescript files', ->
  lessFiles = readDir("src-less")
  for file in lessFiles then do (file) ->
    file = file.split("src-less/")[1]
    child = exec 'lessc src-less/' + file + ' > resources/public/css/' + file.split(".")[0] + '.css', (err, stdout, stderr) ->
      console.log err if err
    child.stdout.pipe process.stdout
    child.stderr.pipe process.stderr

task 'startserver', 'start server in dev mode', ->
  child = exec 'lein ring server', (err, stdout, stderr) ->
    throw err if err
  child.stdout.pipe process.stdout

task 'generate-testdata', 'generates the test data', ->
  child = exec 'lein setup-db', (err, stdout, stderr) ->
    throw err if err
  child.stdout.pipe process.stdout

task 'build-cs', 'concat coffee files', ->
  child = exec 'python jc.py | coffee --compile --stdio > resources/public/js/chat.js', (err, stdout, stderr) ->
  child.stdout.pipe process.stdout

task 'dev', 'start server and compile assets', ->
  invoke 'startserver'
  invoke 'generate-testdata'
  invoke 'build-cs'
  invoke 'build-less'
  watch "src-less", -> invoke 'build-less'
  watch "src-cs", -> invoke 'build-cs'
