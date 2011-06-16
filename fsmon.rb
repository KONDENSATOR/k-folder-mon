#!/usr/bin/env ruby

path = File.dirname(__FILE__)
Dir.chdir path

require 'helpers' #File.join(path, 'helpers')
require 'yaml'

settings = YAML::load(File.open(File.expand_path("~/.fsmon")))

@folders  = settings['folders']
@filters  = settings['filters']
@user     = settings['user']

fs_events_accumulated @folders, @filters do |folder, changes|
  change_str = changes.map { |change|
    file = change[:file].sub(folder, '')
    
    "#{change[:event]} #{file}" 
  }.join(';')
  
  ["./sync_git.rb '#{folder}' '#{change_str}'", @user]
end
