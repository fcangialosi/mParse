require 'rubygems'
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'

class Parser
  def parse_tally_tables (input, file_type, output)
    output_file = File.open(input, 'r')
    sheet = nil
    book = Spreadsheet::Workbook.new 
    tables = 0 
    row = 0

    start_regex = /(\d+tally)\s*(\d+)/
    table_regex = /\s(\d*\.\d*E{0,1}(\+|\-)\d*)\s*(\d*\.\d*E{0,1}(\+|\-)\d*)\s*(\d*.\d*)/
    ending_regex = /\s*(total)\s*(\d+.\d*E[+-]\d*) (\d+.\d*)/
    surface_regex = /^\s*(surface \([0-9. ]*\))\s*$/
    cell_regex = /^\s*(cell\s*\d+)\s*$/
    reading = false
    extra_info = false

    lines = output_file.readlines
    lines.each do |line|
      start = line.match(start_regex) unless reading
      if(!start.nil?)
      	sheet = book.create_worksheet :name => "#{start[1]}#{start[2]}"
        puts "==Parsing Tally Table No.#{start[2]}"
        tables += 1
        type = start[2].to_s[-1].to_i
        sheet.update_row 0, "#{start[1]}", "table \##{start[2]}", "tally type #{type}"
      	sheet.update_row 2, "energy","surface current", "relative error"
        row = 3
      	reading = true
      end
      if(reading)
        if(line.include?("energy bins")) then
          book.delete_worksheet(book.worksheets.index(sheet))
          reading = false
          extra_info = false
          tables -= 1
        end
      	table_data = line.match(table_regex)
        surface_data = line.match(surface_regex) unless extra_info
        cell_data = line.match(cell_regex) unless extra_info
        if(!surface_data.nil?)
          sheet.row(0).push("#{surface_data[1]}")
          extra_info = true
        end
        if(!cell_data.nil?)
          sheet.row(0).push("#{cell_data[1]}")
          extra_info = true
        end
      	if(!table_data.nil?)
          sheet.update_row row, "#{table_data[1]}","#{table_data[3]}","#{table_data[5]}"
          row += 1
      	else 
          ending = line.match(ending_regex)
      	  if(!ending.nil?)
      	    sheet.update_row row, "#{ending[1]}","#{ending[2]}","#{ending[3]}"
      	    reading = false
            extra_info = false
      	  end
      	end
      end 
    end
    puts "==Writing to #{output}..."
    book.write(output)
    puts "==Succesfully parsed #{tables} tables."
  end
end