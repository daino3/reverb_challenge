require 'date'

class Person
	attr_accessor :first_name, :last_name, :date_of_birth, :gender, :favorite_color

	def initialize(params)
		@first_name     = params.fetch(:firstname).capitalize
		@last_name      = params.fetch(:lastname).capitalize
		@date_of_birth  = params.fetch(:dateofbirth)
		@gender 		= params.fetch(:gender).capitalize
		@favorite_color = params.fetch(:favoritecolor).capitalize
	end

	def properties
	  [self.last_name, self.first_name, self.gender, self.date_of_birth.strftime('%m/%d/%Y').to_s, self.favorite_color]
	end
end