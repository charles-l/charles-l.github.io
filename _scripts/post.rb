# from https://gist.githubusercontent.com/ivey/49630/raw/da002fc17e565b54aa1d307421a7140309cc5aff/jekyll.thor

require 'fileutils'
require 'date'
include FileUtils

def draft(name)
        format = "markdown"
        slug = name.downcase.gsub(/ +/,'-').gsub(/[^-\w]/,'').sub(/-+$/,'')
        filename = slug + ".#{format}"
        mkdir_p "_drafts"
        if File.exists?("_drafts/#{filename}")
                puts "#{filename} already exists!"
                return
        end
        File.open("_drafts/#{filename}","w+") do |f|
                f.puts "---"
                f.puts "layout: post"
                f.puts "title: #{name}"
                f.puts "---"
        end
        puts "Created _drafts/#{filename}"
end

def publish(file=nil)
        unless file
                puts "Choose file:"
                @files = Dir["_drafts/*"]
                @files.each_with_index { |f,i| puts "#{i+1}: #{f}" }
                print "> "
                num = STDIN.gets
                file = @files[num.to_i - 1]
        else
                abort "File doesn't exist!" if File.file?(file)
        end
        now = Date.today.strftime("%Y-%m-%d").gsub(/-0/,'-')
        mv file, "_posts/#{now}-#{File.basename(file)}"
end

a = ARGV.shift
if a == "draft"
        abort("you didn't pass a filename!") unless d = ARGV.shift
        draft(d)
        exit
end
if a == "publish"
        publish(ARGV.shift)
        exit
end

puts "post.rb SUBCOMMAND [OPTIONS]"
puts "  draft NAME        create a draft"
puts "  publish [NAME]    publish a draft"
