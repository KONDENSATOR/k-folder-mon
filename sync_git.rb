#!/usr/bin/env ruby

require 'rubygems'
require 'real_growl'

@event_types = {
  '-1' => 'FSE_INVALID',
  '0' => 'FSE_CREATE_FILE',
  '1' => 'FSE_DELETE',
  '2' => 'FSE_STAT_CHANGED',
  '3' => 'FSE_RENAME',
  '4' => 'FSE_CONTENT_MODIFIED',
  '5' => 'FSE_EXCHANGE',
  '6' => 'FSE_FINDER_INFO_CHANGED',
  '7' => 'FSE_CREATE_DIR',
  '8' => 'FSE_CHOWN',
}


@event_types_simple = {
  '-1' => 'Invalid',
  '0' => 'Created',
  '1' => 'Deleted',
  '2' => 'Stat changed',
  '3' => 'Renamed',
  '4' => 'Modified',
  '5' => 'Exchanged',
  '6' => 'Finder info changed',
  '7' => 'Created dir',
  '8' => 'Changed owner',
}

sync = RealGrowl::Application.new("Sync git")

folder  = ARGV[0]
files   = ARGV[1].split(';')

growl_folder = File.basename(folder)
growl_msg = ""

files.each do |file|
  m = /(\d+)\s(.*)/.match(file)  
  msg = "#{@event_types_simple[m[1]]} - #{m[2]}\n"
  growl_msg += msg
end

puts growl_msg

icon = File.expand_path("./icon.png")

# Enter directory
Dir.chdir folder

# Add my changes to stage
puts %x{git add -A}

# Commit my changes localy
puts %x{git commit -m "#{files.to_s}"}

# Pull changes from server and merge
pulled = %x{git pull origin master}

m = /\d+ files changed, \d+ insertions\(\+\), \d+ deletions\(\-\)/.match(pulled)

pull_notification = nil
pull_notification = m.to_s if m

sync.notify(
  :title => growl_folder,
  :description => pull_notification,
  :priority => 0,
  :sticky => false,
  :icon => icon) if pull_notification

# Add any merge activities to stage
puts %x{git add -A}

# Commit merge localy
puts %x{git commit -m "merge"}

# Push my changes and merges to server
puts %x{git push origin master}

result = %x{git status}

sync.notify(
  :title => growl_folder, 
  :description => growl_msg, 
  :priority => 0, 
  :sticky => false, 
  :icon => icon)

