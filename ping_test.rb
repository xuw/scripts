require 'net/ssh'
threads = []

start_ip = 1
end_ip = 180

total = end_ip - start_ip + 1

results = Array.new(total){ Array.new(total) {Array.new}}

start_ip.upto end_ip do |num|
  t = Thread.new do
    begin
     ip = "10.1.0.#{num}"
     Net::SSH.start(ip, "root", :password => "root123", :auth_methods => ['password'], :timeout => 10) do |ssh|
         puts "running on #{ip}"
         out = ssh.exec!("seq #{start_ip} #{end_ip} | xargs -i{} -P 90 ping -A -w 10 -c 8 10.1.0.{}")

         out.each_line do |line|
           if (line =~ /.* bytes from (.*): icmp_seq=(.*) ttl=.* time=(.*) ms/)


             seq = $2.to_i
             time = $3.to_f

             dest_ip = $1
             dest_ip =~ /10.1.0.(.*)/
             dest = $1.to_i - start_ip

             from_ind = num.to_i - start_ip

             # puts "from #{ip} to #{dest}: #{time} ms"

             results[from_ind][dest] << time
           end
         end
	#puts out
    end
  rescue
    puts "failed on #{num} #{$!}"
  end
end
  threads << t
  sleep(0.1)
end


sleep 200

threads.each do |t|
  t.exit
end

# threads.each do |t|
#   puts "wating for slow process.... " until t.join(3)
# end

# p results

include Enumerable
cnt = start_ip
results.each do |row|
  row.each do |col|
    avg_time = col.reduce(:+).to_f / col.size
    print "%2.2f " % avg_time
  end
  print "\##{cnt}\n"
  cnt += 1
end
