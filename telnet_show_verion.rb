require_relative 'multi-telnet'
run_cmd() do |telnet, host|
  puts "running on host #{host}"
  telnet.cmd("show version") {|c| print c}
  STDOUT.flush
end
