require 'date'
require 'csv'
require_relative 'person.rb'

module FileParser
  TEXT_FILE = {csv: 'data_files/csv.txt',
               psv: 'data_files/psv.txt',
               ssv: 'data_files/ssv.txt',
               test: 'data_files/test.txt'}
  
  DELIMITERS = [" | ",", ", " "]

  def self.parse(file_location)
    people = []
    file = File.open(file_location)
    separator = find_separator(file)
    CSV.foreach(file, headers: true, header_converters: :symbol, col_sep: separator) do |row|
      people << Person.new(conform_data_format(row).to_hash)
    end
    people
  end

  private

  def self.find_separator(file)
    file_content = file.readline
    DELIMITERS.find do |delimiter|
      file_content.include?(delimiter)
    end
  end

  def self.conform_data_format(data)
    data[:dateofbirth] = conform_date(data[:dateofbirth])
    data[:gender]      = conform_gender(data[:gender])
    data
  end

  def self.conform_date(date)
    date.match(/\//) ? Date.strptime(date, "%m/%d/%Y") : Date.strptime(date, "%m-%d-%Y")
  end

  def self.conform_gender(gender)
    gender.match(/^(m|M)/) ? "Male" : "Female"
  end

end