sleeptime = 0.05 

require 'open3'
report = {}
threads = []

1.upto 20 do |cnt|
1.upto 12 do |num| 
  t = Thread.new do
    ip = "10.0.3.#{num}"
    command = "snmpwalk -v 2c -c Compass #{ip} sysDescr"
    result = `#{command}`
    status = $?.to_i
    report[num] = [ip, status, result]
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
end
