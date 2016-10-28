#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + "/../lib")
require "rubygems"
require "show_in_github"

begin
  url = ShowInGitHub.url_for(ENV['TM_FILEPATH'])
  if ENV['TM_LINE_NUMBER']
    lines = "L#{ENV['TM_LINE_NUMBER']}"
  else
    lines = ENV['TM_SELECTION'].split('-')
                               .collect{ |line| line[/[^:]+/].to_i }
                               .sort
                               .collect{ |line| "L#{line}"}
                               .join('-')
  end

  if ARGV[0] == "copy"
    `echo "#{url}##{lines}" | tr -d '\n' | pbcopy`
    puts "Added #{url}##{lines} to clipboard"
  else
    `open #{url}##{lines}`
  end
rescue NotGitRepositoryError
  puts "File/project not a git repository"
rescue NotGitHubRepositoryError
  puts "File/project has not been pushed to a github repository"
end