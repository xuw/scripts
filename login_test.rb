require 'net/ssh'
report = {}
threads = []
1.upto 182 do |num| 
  t = Thread.new do
    # Net::SCP.upload!("10.1.0.#{num}", "root",
    #     "/home/xuw/fun/minerd", "minerd",
    #     :password => "root", :auth_methods => ['password'])
  begin 
     Net::SSH.start("10.1.0.#{num}", "xuw", :password => "123", :auth_methods => ['password']) do |ssh|
        #out = ssh.exec!("ls -l minerd")
        out = ssh.exec!("ls tcpdump.txt")
	#out = ssh.exec!("/root/minerd -q --url=stratum+tcp://stratum.f2pool.com:8888 --userpass=dradra.ltc#{num}:pass --threads=20 > /dev/null 2>&1 &")
        #out = ssh.exec!("ps -ef | grep minerd")
        #out = ssh.exec!("vmstat")
	puts out
    end
  rescue
    puts "failed on #{num}"
  end
end
  
  threads << t
  sleep(0.2)
end
threads.each do |t|
  puts "wating for slow process.... " until t.join(30)
end

puts "Failed On Nodes:"
report.sort.reject {|k, v| v[1] == 0}.each do |k, v|
  p v
end
