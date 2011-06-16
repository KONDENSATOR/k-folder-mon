#!/usr/bin/env ruby

require 'helpers'

@folders  = ['~/CUSTOMER']
@filters  = [/\.ds_store/, /\.git\//i]
@user     = 'fredrik'

fs_events_accumulated @folders, @filters do |folder, changes|
  change_str = changes.map { |change|
    file = change[:file].sub(folder, '')
    
    "#{change[:event]} #{file}" 
  }.join(';')
  
  ["./sync_git.rb '#{folder}' '#{change_str}'", @user]
end
