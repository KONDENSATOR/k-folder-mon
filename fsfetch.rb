#!/usr/bin/env ruby

path = File.dirname(__FILE__)
Dir.chdir path

require 'helpers'
require 'yaml'

settings = YAML::load(File.open(File.expand_path("~/.fsmon")))

@folders  = settings['folders']
@filters  = settings['filters']
@user     = settings['user']

loop do
  @folders.each do |folder|
    %x{sudo -u #{@user} ./fetch_git.rb '#{File.expand_path(folder)}'}
  end
  sleep(60)
end
