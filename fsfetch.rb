#!/usr/bin/env ruby

require 'helpers'
require 'yaml'

settings = YAML::load(File.open(File.expand_path("~/.fsmon")))

@folders  = settings['folders']
@filters  = settings['filters']
@user     = settings['user']

loop do
  @folders.each do |folder|
    %x{./fetch_git.rb '#{File.expand_path(folder)}'}
  end
  sleep(60)
end
