require 'pry'
require 'date'
require 'csv'
require_relative 'person.rb'

module FileParser
  TEXT_FILE = {csv: 'data_files/csv.txt',
               psv: 'data_files/psv.txt',
               ssv: 'data_files/ssv.txt',
               test: 'data_files/test.txt'}

  def self.parse(file_location)
    people = []
    file = File.open(file_location)
    separator = find_separator(file)
    CSV.foreach(file, headers: true, header_converters: :symbol, col_sep: separator) do |row|
      people << Person.new(conform_data_set(row).to_hash)
    end
    people
  end

  def self.save_to_file(file_location, person)
    info = [person.last_name, person.first_name, person.gender, person.favorite_color, person.date_of_birth.strftime('%m/%d/%Y').to_s]
    File.open(file_location, 'a') do |line|
      line.write("\n"+info.join(', '))
    end
  end

  def self.find_separator(file)
    file_content = file.read
    if file_content.include?("|")
      " | "
    elsif file_content.include?(",")
      ", "
    else
      " "
    end  
  end

  def self.conform_data_set(data)
    data[:dateofbirth] = conform_date_format(data[:dateofbirth])
    data[:gender] = conform_gender_format(data[:gender])
    data    
  end

  def self.conform_date_format(date_string)
    if date_string.match(/\//)
      Date.strptime(date_string, "%m/%d/%Y")
    elsif date_string.match(/-/)
      Date.strptime(date_string, "%m-%d-%Y")
    end
  end

  def self.conform_gender_format(gender_string)
    if gender_string.match(/^(m|M)/)
      "Male"
    elsif gender_string.match(/^(f|F)/)
      "Female"
    end
  end

end
