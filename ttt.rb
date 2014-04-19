require 'net/scp'
report = {}
threads = []
100.upto 135 do |num| 
  t = Thread.new do
  begin 
     Net::SCP.start("10.1.0.#{num}", "root", :password => "root", :auth_methods => ['password']) do |scp|
        scp.upload!("/home/xuw/fun/authorized_keys", "authorized_keys")
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
