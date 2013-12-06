require 'grape'
require 'json'
require_relative 'models/list_of_people.rb'
require_relative 'models/file_parser.rb'
require_relative 'models/person_saver.rb'

module PersonParser
  class AppAPI < Grape::API

    version 'v1', using: :header, vendor: 'dain'
    format :json

    desc 'home page'
      get '/' do
        "Hello"
      end

      files = [FileParser::TEXT_FILE[:csv], FileParser::TEXT_FILE[:psv], FileParser::TEXT_FILE[:ssv]]

      helpers do
        def format_to_hash(sorted_people)
          printer = PeoplePrinter.new(sorted_people)
          printer.convert_to_hash
        end
      end

    resources :people do

      desc 'list all people'
        get '/all' do
          sorted_people = ListofPeople.new(*files).order_by("last_name")
          format_to_hash(sorted_people)
        end

      desc 'list people sorted by gender & last name'
        get '/gender' do
          sorted_people = ListofPeople.new(*files).order_by("gender", "last_name")
          format_to_hash(sorted_people)
        end

      desc 'list people sorted by birthdate'
        get '/birthdate' do
          sorted_people = ListofPeople.new(*files).order_by("date_of_birth", "last_name")
          format_to_hash(sorted_people)
        end

      desc 'list people sorted by last name in reverse order'
        get '/name' do
          sorted_people = ListofPeople.new(*files).order_by("last_name").reverse
          format_to_hash(sorted_people)
        end

        desc 'create a person'
        params do 
          requires :first_name, type: String, desc: "First Name"
          requires :last_name, type: String, desc: "Last Name"
          requires :gender, type: String, desc: "Gender"
          requires :date_of_birth, type: Date, desc: "Date of Birth"
          requires :favorite_color, type: String, desc: "Favorite Color"
        end
        post do
          person = Person.new({firstname: params[:first_name],
                                lastname: params[:last_name],
                                gender: params[:gender],
                                dateofbirth: params[:date_of_birth],
                                favoritecolor: params[:favorite_color]})
          PersonSaver.save_to_file(FileParser::TEXT_FILE[:csv], person)  
        end
    end
  end
end