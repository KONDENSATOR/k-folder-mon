def filter_event(folders, filters, line)
  folders = folders.map { |folder| File.expand_path folder }
  match = /^\/\d+:(\d+):\d+:\d+(.+)/.match line
  event, file = match[1], match[2]
  
  folders.each do |folder|
    if file.start_with? folder
      filters.each do |filter|
        return if filter =~ file
      end
      yield folder, event, file
    end
  end
end

def fs_events(folders, filters)
  folders = folders.map { |folder| File.expand_path folder }
  IO.popen("./fetool") do |io|
    io.each_line do |line|
      filter_event(folders, filters, line) do |folder, event, file|
        yield folder, event, file
      end
    end
  end
end

def pid_active?(pid)
  begin
    Process.getpgid(pid)
    true
  rescue Errno::ESRCH
    false
  end
end

def fs_events_accumulated(folders, filters)
  folders = folders.map { |folder| File.expand_path folder }
  queue = {}
  folders.each { |f| queue[f] = {
    :process => -1,
    :events => []
  } }
  
  fs_events folders, filters do |folder, event, file|
    queue[folder][:events] << { :event => event, :file => file }
    
    if not pid_active?(queue[folder][:process])
      events = queue[folder][:events]
      cmd, user = yield folder, events
      pid = fork {
        %x{sudo -u #{user} #{cmd}}
      }
      Process.detach(pid)
      queue[folder] = {
        :process => pid,
        :events => []
      }
    end
  end
end
