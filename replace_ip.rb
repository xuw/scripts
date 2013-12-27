cmd = "chassis identify 2"
username = "admin"
passwd = "admin"
sleeptime = 0.01

require 'open3'
report = {}
threads = []
IO.readlines("ip.txt").each do |str| 
  t = Thread.new do
    orig, repl = str.split(" ")
    ip_orig = "10.0.0.#{orig}"
    ip_repl = "10.0.0.#{repl}"
    command = "ipmitool -I lanplus -H #{ip_orig} -U #{username} -P #{passwd} lan set 1 ipaddr #{ip_repl}"
    puts command
    
    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      status = $?.to_i
      status = wait_thr.value
      report[orig] = [ip_orig, status, command, stdout.readlines, stderr.readlines]
      puts "#{ip}: (#{status})  #{stdout}"
    end
    p command
  end
  threads << t
  sleep(sleeptime)
end

sleep(200) # successful threads will hang anyways, no need to wait more.
#threads.each do |t|
  #t.join(120)
  #p t
#end

puts "Failed On Nodes:"
report.sort.reject {|k, v| v[1] == 0}.each do |k, v|
  p v
end

