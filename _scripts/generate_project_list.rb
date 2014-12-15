require 'json'
require 'yaml'
require 'open-uri'
user="charles-l"
p = JSON.parse(open("https://api.github.com/users/#{user}/repos").read)
p.sort! {|a,b| a["stargazers_count"]<=>b["stargazers_count"]}
p.reverse!
p = p[0..5]
File.write('./_data/projects.yml', p.to_yaml)
