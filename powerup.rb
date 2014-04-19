cmd = "power on"
#cmd = "chassis bootdev bios"
#cmd = "sensor"
#cmd = "bmc watchdog get"
username = "admin"
passwd = "admin"
sleeptime = 0.1 

require 'open3'
report = {}
threads = []
1.upto 180 do |num| 
  t = Thread.new do
    ip = "10.0.0.#{num}"
    command = "ipmitool -I lanplus -H #{ip} -U #{username} -P #{passwd} #{cmd}"
    result = `#{command}`
    status = $?.to_i
    report[num] = [ip, status, result]
    puts "==== PSU=#{ip} ===="
    puts "#{ip}: (#{status})  #{result}"
  end
  threads << t
  sleep(sleeptime)
end
threads.each do |t|
  puts "wating" until t.join(120)
end

puts "Failed On Nodes:"
report.sort.reject {|k, v| v[1] == 0}.each do |k, v|
  p v
end
