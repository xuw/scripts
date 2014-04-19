require 'net/ssh'
require 'net/scp'
report = {}
threads = []
121.upto 135 do |num| 
  t = Thread.new do
  begin 
    Net::SCP.start("10.1.0.#{num}", "root", :password => "root", :auth_methods => ['password']) do |scp|
     scp.upload("/home/xuw/fun/libpcap-1.5.3.tar.gz", "libpcap.tar.gz")
     scp.upload!("/home/xuw/fun/lirui.sh", "lirui.sh")
    end

       Net::SSH.start("10.1.0.#{num}", "root", :password => "root", :auth_methods => ['password']) do |ssh|
        out = ssh.exec!("sh lirui.sh")
        #out += ssh.exec!("mv authorized_keys .ssh/")
        puts out
        #out += ssh.exec!("ls .ssh")

        #out = ssh.exec!("ls -l minerd")
        #out = ssh.exec!("killall minerd")
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
