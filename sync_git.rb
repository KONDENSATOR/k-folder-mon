#!/usr/bin/env ruby

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

folder  = ARGV[0]
files   = ARGV[1]

# Enter directory
Dir.chdir folder

# Add my changes to stage
puts %x{git add -A}

# Commit my changes localy
puts %x{git commit -m "#{files.to_s}"}

# Pull changes from server and merge
puts %x{git pull origin master}

# Add any merge activities to stage
puts %x{git add -A}

# Commit merge localy
puts %x{git commit -m "merge"}

# Push my changes and merges to server
puts %x{git push origin master}
