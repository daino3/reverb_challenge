require 'pry'
require_relative 'models/list_of_people.rb'
require_relative 'models/people_printer.rb'
require_relative 'models/file_parser.rb'

people = ListofPeople.new(FileParser::TEXT_FILE[:csv],FileParser::TEXT_FILE[:psv], FileParser::TEXT_FILE[:ssv])

def sort_and_print(people, *properties)
  sorted_people = people.order_by(*properties)
  PeoplePrinter.new(sorted_people).print_people
end

puts '----------------'
puts "Output 1:"
sort_and_print(people,"gender", "last_name")
puts '----------------'
puts "Output 2:"
sort_and_print(people,"date_of_birth", "last_name")
puts '----------------'
puts "Output 3:"
sort_and_print(people,"last_name").reverse