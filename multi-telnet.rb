require 'optparse'
require 'net/telnet'

def run_cmd()

options = {}
option_parser = OptionParser.new do |opts|
  opts.banner = 'help'
  opts.on('-s SCRIPT', '--script SCRIPT', 'script to execute in telnet') do |value|
    options[:script] = value
  end
  opts.on('-h host1,host2', '--hosts host1,host2', Array, 'List of Hosts') do |ips|
    options[:hosts] = ips
  end
  opts.on('-f fn', '--host_file filename', 'file of a list of hosts') do |file|
    options[:file] = file
  end
end.parse!

p options

ips = []
if options[:file]
  ips = IO.readlines(options[:file])
end
if options[:hosts]
  ips = options[:hosts]
end
failures = []

ips.each do |host| 
  begin 
    puts "running on ======== #{host} ========"
    puts
    telnet = Net::Telnet.new("Host" => host) {|c| print c}
    telnet.login("admin", "pica8") {|c| print c}
     
    yield telnet, host

    telnet.cmd("exit") {|c| print c}
    telnet.close
    puts
  rescue Exception => ex
    failures << host + " "  + ex.to_s
    p ex
  end
end
puts
puts "Failures:"
p failures
end

#run_cmd() do |telnet| 
#  telnet.cmd("show version") {|c| print c}
#  STDOUT.flush
#end

