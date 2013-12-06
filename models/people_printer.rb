class PeoplePrinter

  def initialize(list_of_people)
    @list_of_people = list_of_people
  end

  def convert_to_hash
    container = {}
    @list_of_people.each_with_index do |person, index|
      container[index+1] = person.properties
    end
    container
  end

  def print_people
    convert_to_array.each do |person_array|
      puts person_array.join(', ')
    end
  end

  private

  def convert_to_array
    @list_of_people.map(&:properties)
  end
end