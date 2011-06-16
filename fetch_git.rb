#!/usr/bin/env ruby

require 'rubygems'
require 'real_growl'

sync = RealGrowl::Application.new("Sync git")

folder = ARGV[0]

icon = File.expand_path("./icon.png")

# Enter directory
Dir.chdir folder

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
