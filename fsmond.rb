#!/usr/bin/env ruby

path = File.dirname(__FILE__)
Dir.chdir path

require 'rubygems'        # if you use RubyGems
require 'daemons'

Daemons.run('fsmon.rb')
