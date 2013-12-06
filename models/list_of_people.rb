require 'date'
require_relative 'file_parser.rb'
require_relative 'people_printer.rb'

class ListofPeople

  def initialize(*file_locations)
    @people = get_people(*file_locations)
  end

  def order_by(*properties)
    @people.sort_by do |person| 
      properties.map { |property| person.send(property) }
    end
  end

  private

  def get_people(*file_locations)
    file_locations.map do |file| 
      FileParser.parse(file) 
    end.flatten
  end

end