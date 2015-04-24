desc "generate project list"
task :gen_project_list do
	`ruby _scripts/generate_project_list.rb`
end

desc "build site"
task :build => :gen_project_list do
	`jekyll build .`
	`cp CNAME ./_site/`
end

desc "start the server"
task :start_server do
	`shusd ./_site/`
end
