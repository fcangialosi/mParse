def parse_tally_tables (input, file_type, output)
  output_file = File.open(input, 'r')
  write_file = nil
  tables = 0 

  start_regex = /(\d+tally)\s*(\d+)/
  table_regex = /\s(\d*\.\d*E{0,1}(\+|\-)\d*)\s*(\d*\.\d*E{0,1}(\+|\-)\d*)\s*(\d*.\d*)/
  ending_regex = /\s*(total)\s*(\S*) (\S*)$/
  reading = false

  lines = output_file.readlines
  lines.each do |line|
    start = line.match(start_regex)
    if(!start.nil?)
    	write_file = File.open("#{start[1]}#{start[2]}.csv", 'w')
      puts "==Parsing Tally Table No.#{start[2]}"
      tables += 1
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
    	    write_file.write("#{ending[1]},#{ending[2]},#{ending[3]},\n")
    	    reading = false
    	  end
    	end
    end
  end

  puts "==Succesfully parsed #{tables} tables."
end

def interpreter 
  puts "\n"
  puts "===== MCNPX Output File Parser | Version 0.1 ===== \n"
  puts "Type \"help\" for more info, and \"done\" to finish"
  puts "\n"
  loop do
    print "> "
    line = STDIN.gets
    case line.strip
      when "done"
        return
      when "help"
        puts "\nAvailable commands:"
        puts "1. extract -> Extract specific information of an MCNPX output file"
        puts "2. clear -> Clear out all files of a given type in the current directory"
        puts "3. show files -> List all the files in your current directory"
        puts "4. done -> exit the shell"
        puts "\n"
        puts "Type \"help <command>\" to learn more about a specific command"
      when "help extract"
        puts "1. Type the full path to your file. No path is necessary if the file is located in the current directory."
        puts "2. Information types include: "
        puts "   - Tally Tables"
        puts "3. File creation types include: "
        puts "   - excel/spreadsheet"
        puts "   - pdf"
        puts "4. Type the path of the directory you would like to save the new files into. Simply press enter if you would like to save the files to the current directory."
        print "\n"
      when "clear"
        print "What would you like to clear out? "
        type = STDIN.gets.strip
        if(type.include?("spreadsheet") || type.include?("excel"))
          Dir.new('.').each {|file| if(file.include?("csv")) then File.delete(file) end }
        end
      when "show files"
        Dir.new('.').each {|file| puts "#{file}"}
      when "extract"
        print "Where is your MCNPX output file? "
        input = STDIN.gets.strip
        print "What information would you like to extract? " 
        type = STDIN.gets.strip
        print "What kind of file would you like to create? "  
        file_type = STDIN.gets.strip
        print "Where would you like to save the file? (Defaults to current dir) "
        output = STDIN.gets.strip
        if(type.include?('tally'))
          puts "==Extracting tally tables from #{input} into #{output}"
          puts "=="
          parse_tally_tables(input,file_type,output)
        end
      else 
        puts "That's not a valid command. Try \"help\" to see a list of available commands." 
      end
  end
end

interpreter