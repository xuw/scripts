require 'net/ssh'
report = {}
threads = []
all_nodes = (1..180).to_a
all_nodes += (202..208).to_a

all_nodes.each do |num| 
  t = Thread.new do
    begin
     Net::SSH.start("10.1.0.#{num}", "root", :password => "root123", :auth_methods => ['password']) do |ssh|   
        #out = ssh.exec!("date")
        out = ssh.exec!("shutdown -h now")
        puts out
     end
  rescue
    puts "failed on #{num} #{$!}"
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
