require 'pry'
require_relative 'models/list_of_people.rb'
require_relative 'models/people_printer.rb'
require_relative 'models/file_parser.rb'

people = ListofPeople.new(FileParser::TEXT_FILE[:csv],FileParser::TEXT_FILE[:psv], FileParser::TEXT_FILE[:ssv])

puts '----------------'
puts "Output 1:"
sorted_people = people.order_by("gender", "last_name")
PeoplePrinter.print_people(PeoplePrinter.map_people_to_attributes(sorted_people))
puts '----------------'
puts "Output 2:"
sorted_people = people.order_by("date_of_birth", "last_name")
PeoplePrinter.print_people(PeoplePrinter.map_people_to_attributes(sorted_people))
puts '----------------'
puts "Output 3:"
sorted_people = people.order_by("last_name").reverse
PeoplePrinter.print_people(PeoplePrinter.map_people_to_attributes(sorted_people))
