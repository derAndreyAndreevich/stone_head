os = require "os"
pkg = require "./package.json"
TMPDIR = os.tmpdir()


module.exports = (grunt) ->
  # console.log "nimrod c --out:#{pkg.name} --nimcache:#{TMPDIR} -d:useGlew main.nim"
  grunt.initConfig
    mkdir:
      build:
        options:
          create: ["build"]
    shell:
      options:
        stderr: true
      compile:
        command: "nimrod c --out:#{pkg.name} --nimcache:#{TMPDIR}/nimcacne-#{pkg.name} -d:useGlew main.nim"
      createBuild:
        command: [
          "rm -rf build"
          "mkdir build"
          "cp #{pkg.name}.exe build/#{pkg.name}.exe"
          "rm #{pkg.name}.exe"
        ].join ";"
    watch:
      files: ["../nimrod/catty/**/*.nim", "**/*.nim"]
      tasks: ["mkdir", "shell"]


  grunt.loadNpmTasks "grunt-shell"
  grunt.loadNpmTasks "grunt-mkdir"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-watch"

  

  grunt.registerTask "default", ["mkdir", "shell"]