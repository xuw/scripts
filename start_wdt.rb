username = "admin"
passwd = "admin"
sleeptime = 0.05  

report = {}
threads = []
201.upto 201 do |num| 
  t = Thread.new do
    ip = "10.0.0.#{num}"
    command = "ipmiutil wdt -e -t180 -N #{ip} -U #{username} -P #{passwd}"
    result = `#{command}`
    status = $?.to_i
    report[num] = [ip, status, result]
    #puts "#{ip}: (#{status})  #{result}"
  end
  threads << t
  sleep(sleeptime)
end
threads.each do |t|
  t.join(30)
end

#puts "Failed On Nodes:"
report.sort.reject {|k, v| v[1] == 0}.each do |k, v|
  #p v
end
