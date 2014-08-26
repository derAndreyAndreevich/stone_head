require "tmpdir"

project_name = "shone_head"
build_dir = "#{Dir.pwd}/.build"
src_dir = "#{Dir.pwd}"

task :default do

    nimcache = "--nimcache:#{Dir.tmpdir}/nimcache-#{project_name}"
    use_glew = "-d:useGlew"

    sh "nimrod c --out:#{build_dir}/#{project_name} #{nimcache} #{use_glew} main.nim "
    sh "#{build_dir}/#{project_name}"
end