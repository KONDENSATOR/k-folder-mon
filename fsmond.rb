#!/usr/bin/env ruby

require 'rubygems'        # if you use RubyGems
require 'daemons'

Daemons.run('fsmon.rb')
Daemons.run('fsfetch.rb')
