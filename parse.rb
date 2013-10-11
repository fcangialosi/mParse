output_file = File.open(ARGV[0], 'r')
write_file = nil

start_regex = /(\d+tally)\s*(\d+)/
table_regex = /\s(\d*\.\d*E{0,1}(\+|\-)\d*)\s*(\d*\.\d*E{0,1}(\+|\-)\d*)\s*(\d*.\d*)/
ending_regex = /\s*(total)\s*(\S*) (\S*)$/
reading = false

lines = output_file.readlines
lines.each do |line|
  start = line.match(start_regex)
  if(!start.nil?)
  	puts "START: #{start[1].inspect} #{start[2].inspect}"
  	write_file = File.open("#{start[1]}#{start[2]}.csv", 'w')
  	write_file.write("#{start[1]},#{start[2]},\n\n")
  	write_file.write("energy,surface current, relative error,\n")
  	reading = true
  end
  if(reading)
  	table_data = line.match(table_regex)
  	if(!table_data.nil?)
      write_file.write("#{table_data[1]},#{table_data[3]},#{table_data[5]},\n")
  	else 
  	  ending = line.match(ending_regex)
  	  if(!ending.nil?)
  	    puts "END: #{ending[1].inspect} #{ending[2].inspect} #{ending[3].inspect}"
  	    write_file.write("#{ending[1]},#{ending[2]},#{ending[3]},\n")
  	    reading = false
  	  end
  	end
  end
end
