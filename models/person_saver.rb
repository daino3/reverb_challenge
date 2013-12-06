module PersonSaver

  def self.save_to_file(file_location, person)
    info = to_csv(person)
    File.open(file_location, 'a') do |line|
      line.write("\n"+info.join(', '))
    end
  end

  private

  def self.to_csv(person)
    [person.last_name, person.first_name, person.gender, person.favorite_color, person.date_of_birth.strftime('%m/%d/%Y').to_s]
  end
end