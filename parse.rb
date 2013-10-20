require 'rubygems'
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'

class Parser
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
end