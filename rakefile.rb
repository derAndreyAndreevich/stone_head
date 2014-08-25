require "tmpdir"

project_name = "shone_head"
build_dir = "#{Dir.pwd}/build"
src_dir = "#{Dir.pwd}"

task :default do

    nimcache = "--nimcache:#{Dir.tmpdir}/nimcache-#{project_name}"
    use_glew = "-d:useGlew"

    # puts "nimrod c -r --out:#{project_name} #{nimcache} #{use_glew} main.nim"
    sh "nimrod c --out:#{project_name} #{nimcache} #{use_glew} --import:#{src_dir} main.nim "
    # sh "#{project_name}"

end