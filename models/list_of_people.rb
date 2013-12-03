require 'date'
require 'pry'
require_relative 'file_parser.rb'
require_relative 'people_printer.rb'

class ListofPeople
  include FileParser
  include PeoplePrinter

  def initialize(*file_locations)
    @people = get_people(*file_locations)
  end

  def get_people(*file_locations)
    list_of_people_objects = []
    file_locations.each do |file| 
      list_of_people_objects << FileParser.parse(file) 
    end
    list_of_people_objects.flatten
  end

  def order_by(*properties)
    @people.sort_by do |person| 
      properties.map { |property| person.send(property) }
    end
  end
end