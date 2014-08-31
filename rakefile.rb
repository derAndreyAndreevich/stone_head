require "tmpdir"

project_name = "stone_head"
build_dir = "#{Dir.pwd}/.build"
src_dir = "#{Dir.pwd}"

task :default do

    nimcache = "--nimcache:#{Dir.tmpdir}/nimcache-#{project_name}"
    use_glew = "-d:useGlew"

    sh "nimrod c --out:#{project_name} #{nimcache} #{use_glew} main.nim"
end