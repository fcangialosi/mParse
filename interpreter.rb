require './parse.rb'

def router (input, type, file_type, output)
  if(type.include?('tally'))
    puts "==Extracting tally tables from #{input} into #{output}"
    @parser.parse_tally_tables(input,file_type,output)
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

def print_version
  puts "===============================================================\n"
  puts "========================= Version 0.5 ========================= \n"
  puts "===============================================================\n\n"
  puts "Type \"help\" for more info, or \"done\" to exit the interpreter"
end


def interpreter 
  puts "\n"
  print_name
  print_version
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

@parser = Parser.new
interpreter