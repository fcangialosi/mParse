output_file = File.open(ARGV[0], 'r')

start_regex = /\d+tally\s*\d+\s*\z/
data_regex = /(\d+.\d+E\+|\-\d+  to  \d+.\d+E\+\d+ mev\s*)/
sub_regex = /(\d+.\d+E\+|\-\d+)/ 
write_file = File.open('default', 'w')

lines = output_file.readlines
lines.each do |line|
  start = line.match(start_regex)
  if(!start.nil?) then
  	write_file = File.open("#{start}.csv", 'w') 
  	write_file.write("#{start},\n\n")
  else
    data = line.match(data_regex)
    #values = data.match(sub_regex) unless data.nil?
    write_file.write("#{data}\n") unless data.nil?
  end
end