
module PeoplePrinter

	def self.map_people_to_attributes(list_of_people)
		list_of_people.map do |person|
			person.properties
		end
	end

	def self.map_people_to_attributes_in_hash(list_of_people)
		container = {}
		list_of_people.each_with_index do |person, index|
			container[index+1] = person.properties
		end
		container
	end

	def self.print_people(list_of_people)
	  list_of_people.each do |person_array|
	    puts person_array.join(', ')
	  end
	end

end
