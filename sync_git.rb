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

sync = RealGrowl::Application.new("Sync git")

folder  = ARGV[0]
files   = ARGV[1]

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
  :title => folder,
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

sync.notify(:title => folder, :description => files.to_s, :priority => 0, :sticky => false, :icon => icon)
