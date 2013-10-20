require 'rubygems'
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'

def parse_tally_tables (input, file_type, output)
  output_file = File.open(input, 'r')
  sheet = nil
  book = Spreadsheet::Workbook.new 
  tables = 0 
  row = 2

  start_regex = /(\d+tally)\s*(\d+)/
  table_regex = /\s(\d*\.\d*E{0,1}(\+|\-)\d*)\s*(\d*\.\d*E{0,1}(\+|\-)\d*)\s*(\d*.\d*)/
  ending_regex = /\s*(total)\s*(\S*) (\S*)$/
  reading = false

  lines = output_file.readlines
  lines.each do |line|
    start = line.match(start_regex)
    if(!start.nil?)
    	sheet = book.create_worksheet :name => "#{start[1]}#{start[2]}"
      puts "==Parsing Tally Table No.#{start[2]}"
      tables += 1
      sheet.update_row 0, "#{start[1]}", "#{start[2]}"
    	sheet.update_row 1, "energy","surface current", "relative error"
      row = 2
    	reading = true
    end
    if(reading)
    	table_data = line.match(table_regex)
    	if(!table_data.nil?)
        sheet.update_row row, "#{table_data[1]}","#{table_data[3]}","#{table_data[5]}"
        row += 1
    	else 
    	  ending = line.match(ending_regex)
    	  if(!ending.nil?)
    	    sheet.update_row row, "#{ending[1]}","#{ending[2]}","#{ending[3]}"
    	    reading = false
    	  end
    	end
    end
  end
  puts "==Writing to #{output}..."
  book.write(output)
  puts "==Succesfully parsed #{tables} tables."
end

def router (input, type, file_type, output)
  if(type.include?('tally'))
    puts "==Extracting tally tables from #{input} into #{output}"
    parse_tally_tables(input,file_type,output)
  end
end

def interpreter 
  puts "\n"
  print_name
  puts "===============================================================\n"
  puts "========================= Version 0.5 ========================= \n"
  puts "===============================================================\n\n"
  puts "Type \"help\" for more info, or \"done\" to exit the interpreter"
  puts "\n"
  loop do
    print "> "
    begin 
      line = STDIN.gets
      case line.strip
        when "done" 
          puts "\nGoodbye."
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
          puts "1. Type the full path to your file. No path is necessary if the file is \n   located in the current directory."
          puts "2. Information types include: "
          puts "   - Tally Tables"
          puts "3. File creation types include: "
          puts "   - excel/spreadsheet"
          puts "   - pdf"
          puts "4. Type the path of the directory you would like to save the new files into.\n   Simply press enter if you would like to save the files to the current\n   directory."
          print "\n"
        when "clear"
          print "What would you like to clear out? "
          type = STDIN.gets.strip
          if(type.include?("spreadsheet") || type.include?("excel") || type.include?("xls"))
            puts "Are you sure? (Y/N) "
            sure = STDIN.gets.strip.downcase
            if(sure.include?("y")) then
              Dir.new('.').each {|file| if(file.include?("xls")) then File.delete(file) end }
            else
              puts "Nothing was cleared." 
            end
          else 
            puts "Sorry, that file type is not supported yet. Nothing was cleared."
          end
        when "show files"
          Dir.new('.').each {|file| puts "#{file}"}
        when "extract"
          puts "Where is your MCNPX output file?"
          puts "(Type path to file, or just the file name if in the current directory)"
          print ">>> "
          input = STDIN.gets.strip.downcase
          while(!File.exist?(input))
            puts "\nThat file does not exist."
            print "\n>>> "
            input = STDIN.gets.strip.downcase
          end
          puts "\nWhat information would you like to extract?" 
          puts "(Options: Tally Tables)"
          print ">>> "
          type = STDIN.gets.strip.downcase
          while(!type.include?('tally'))
            puts "That is not a valid information type."
            print "\n>>> "
            type = STDIN.gets.strip.downcase
          end
          puts "\nWhat kind of file would you like to create?" 
          puts "(Options: Spreadsheet, PDF)"
          print ">>> "
          file_type = STDIN.gets.strip.downcase
          while(!file_type.include?("spread") && !file_type.include?("pdf"))
            puts "Sorry, that file type is not supported yet."
            print "\n>>> "
            file_type = STDIN.gets.strip.downcase
          end
          puts "\nWhere would you like to save the file?"
          puts "(Type path to file, or enter for current directory)"
          print ">>> "
          output = STDIN.gets.strip.downcase
          
          router(input,type,file_type,output)
        else 
          puts "That's not a valid command. Try \"help\" to see a list of available commands." 
        end
      rescue Interrupt => e
        puts "\n\nGoodbye."
        return
      end
  end
end

def print_name
  mcnp = "       \_\_    \_\_     \_\_\_\_\_\_     \_\_   \_\_     \_\_\_\_\_\_               
      \/\\ \"\-\.\/  \\   \/\\  \_\_\_\\   \/\\ \"\-\.\\ \\   \/\\  \=\= \\              
      \\ \\ \\\-\.\/\\ \\  \\ \\ \\\_\_\_\_  \\ \\ \\\-\.  \\  \\ \\  \_\-\/              
       \\ \\\_\\ \\ \\\_\\  \\ \\\_\_\_\_\_\\  \\ \\\_\\\\\"\\\_\\  \\ \\\_\\                
        \\\/\_\/  \\\/\_\/   \\\/\_\_\_\_\_\/   \\\/\_\/ \\\/\_\/   \\\/\_\/"              
    
  output = "                                                            
 \_\_\_\_\_\_     \_\_  \_\_     \_\_\_\_\_\_   \_\_\_\_\_\_   \_\_  \_\_     \_\_\_\_\_\_      
\/\\  \_\_ \\   \/\\ \\\/\\ \\   \/\\\_\_  \_\\ \/\\  \=\= \\ \/\\ \\\/\\ \\   \/\\\_\_  \_\\     
\\ \\ \\\/\\ \\  \\ \\ \\\_\\ \\  \\\/\_\/\\ \\\/ \\ \\  \\\_\- \\ \\ \\\_\\ \\  \\\/\_\/\\ \\\/     
 \\ \\\_\_\_\_\_\\  \\ \\\_\_\_\_\_\\    \\ \\\_\\  \\ \\\_\\    \\ \\\_\_\_\_\_\\    \\ \\\_\\     
  \\\/\_\_\_\_\_\/   \\\/\_\_\_\_\_\/     \\\/\_\/   \\\/\_\/     \\\/\_\_\_\_\_\/     \\\/\_\/"     
   
  parser = "                                                             
 \_\_\_\_\_\_   \_\_\_\_\_\_     \_\_\_\_\_\_     \_\_\_\_\_\_     \_\_\_\_\_\_     \_\_\_\_\_\_    
\/\\  \=\= \\ \/\\  \_\_ \\   \/\\  \=\= \\   \/\\  \_\_\_\\   \/\\  \_\_\_\\   \/\\  \=\= \\   
\\ \\  \_\-\/ \\ \\  \_\_ \\  \\ \\  \_\_\<   \\ \\\_\_\_  \\  \\ \\ \_\_\\    \\ \\  \_\_\<   
 \\ \\\_\\    \\ \\\_\\ \\\_\\  \\ \\\_\\ \\\_\\  \\\/\\\_\_\_\_\_\\  \\ \\\_\_\_\_\_\\  \\ \\\_\\ \\\_\\ 
  \\\/\_\/     \\\/\_\/\\\/\_\/   \\\/\_\/ \/\_\/   \\\/\_\_\_\_\_\/   \\\/\_\_\_\_\_\/   \\\/\_\/ \/\_\/"
                                                                
  puts mcnp
  sleep 1
  puts output
  sleep 1
  puts parser
  sleep 1

  puts "\n\n\n"
end

interpreter
