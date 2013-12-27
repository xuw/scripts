cmd = "chassis identify 2"
username = "admin"
passwd = "admin"
sleeptime = 1 

require 'open3'
report = {}
threads = []
1.upto 182 do |num| 
  t = Thread.new do
    ip = "10.0.0.#{num}"
    command = "ipmitool -I lanplus -H #{ip} -U #{username} -P #{passwd} #{cmd}"
    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      #status = $?.to_i
      status = wait_thr.value
      report[num] = [ip, status, stdout.readlines, stderr.readlines]
      puts "#{ip}: (#{status})  #{stdout}"
    end
  end
  threads << t
  sleep(sleeptime)
end
threads.each do |t|
  puts "wating for slow process.... " until t.join(30)
end

puts "Failed On Nodes:"
report.sort.reject {|k, v| v[1] == 0}.each do |k, v|
  p v
end
