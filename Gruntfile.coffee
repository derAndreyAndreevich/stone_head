os = require "os"
pkg = require "./package.json"
TMPDIR = os.tmpdir()


module.exports = (grunt) ->
  console.log "nimrod c --out:.build/#{pkg.name} --nimcache:#{TMPDIR}/nimcacne-#{pkg.name} -d:useGlew -d:release --verbosity:3 main.nim"
  grunt.initConfig
    mkdir:
      build:
        options:
          create: [".build"]
    shell:
      options:
        stderr: true
      compile:
        command: "nimrod c --out:.build/#{pkg.name} --nimcache:#{TMPDIR}/nimcacne-#{pkg.name} -d:useGlew main.nim"
    watch:
      files: ["../nimrod/catty/**/*.nim", "**/*.nim", "../catty/**/*.nim"]
      tasks: ["mkdir", "shell:compile"]

  grunt.loadNpmTasks "grunt-shell"
  grunt.loadNpmTasks "grunt-mkdir"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", ["mkdir", "shell:compile"]
