require 'rspec'
require 'pry'
require 'simplecov'
require 'rack/test'
SimpleCov.start

require_relative 'models/person.rb'
require_relative 'models/file_parser.rb'
require_relative 'models/list_of_people.rb'
require_relative 'app_api.rb'

describe Person do

  it 'has accessible attributes' do
    person = Person.new({firstname:'Dain', 
                         lastname: 'Hall',
                         gender: 'M',
                         dateofbirth: '2000-07-14', 
                         favoritecolor: 'Blue'})
    expect(person.first_name).to eq('Dain')
    expect(person.last_name).to eq('Hall')
    expect(person.gender).to eq('M')
    expect(person.date_of_birth).to eq('2000-07-14')
    expect(person.favorite_color).to eq('Blue')
  end
end

describe ListofPeople do
  let(:people) { ListofPeople.new(FileParser::TEXT_FILE[:csv],FileParser::TEXT_FILE[:psv], FileParser::TEXT_FILE[:ssv]) }

  describe 'ListofPeople.new' do
    it 'initializes with file names and returns a ListofPeople object' do
      expect(people).to be_an(ListofPeople)
    end

  describe '#order_by_by'
    it 'sorts ListofPeople object' do
      expect(people.order_by("favorite_color").first.favorite_color).to eq("Black")
      expect(people.order_by("favorite_color").last.favorite_color).to eq("Yellow")  
    end
  end
end

describe FileParser do

  describe "#parse" do
    let(:parsed_file) { FileParser.parse(FileParser::TEXT_FILE[:psv]) }

    it 'returns an array' do
      expect(parsed_file).to be_an(Array)
    end

    it 'returns an array of people objects' do
      expect(parsed_file.first).to be_an(Person)
    end

    it 'returns an array of people objects with accessible attributes' do
      expect(parsed_file.first.first_name).to eq('Steve')
    end

    it 'conforms date formats' do
      expect(parsed_file.first.date_of_birth).to be_an(Date)
    end

    it 'conforms gender formats' do
      expect(parsed_file.first.gender).to eq(('Male' || 'Female'))
    end
  end

  describe '#save_to_file' do
    let(:file) { File.open(FileParser::TEXT_FILE[:test]) }
    let(:person) { Person.new(firstname: "Test",
                              lastname: "McTester",
                              gender: "Female",
                              dateofbirth: Date.parse("2011-07-14"),
                              favoritecolor: "Blue") }
    
    it 'saves to the test file in csv format' do
      FileParser.save_to_file(file, person)
      file.read.should include(("McTester" && "Test" && "Male" && "Blue" && "07/14/2011"))
    end
  end
end

describe PersonParser::AppAPI do
  include Rack::Test::Methods

  def app
    PersonParser::AppAPI
  end

  describe PersonParser::AppAPI do
    let(:person) { Person.new(firstname: "Test",
                              lastname: "McTester",
                              gender: "Female",
                              dateofbirth: Date.parse("2011-07-14"),
                              favoritecolor: "Blue") }
    
    describe "GET /people/all" do
      it "returns rendered records" do
        get "/people/all"
        people = JSON.parse(last_response.body)
        rendered_person = people["1"]
        last_response.status.should == 200
        (rendered_person.include?('Male') || rendered_person.include?('Female')).should be_true 
      end
    end

    describe "GET /people/name" do
      it "sorts folks by last name in reverse order" do
        get "/people/name"
        people = JSON.parse(last_response.body)
        first_last_name = people["1"][0]
        second_last_name = people["2"][0]
        last_response.status.should == 200
        (first_last_name > second_last_name).should be_true
      end
    end

    describe "GET /people/gender" do
      it "sorts folks by gender" do
        get "/people/gender"
          people = JSON.parse(last_response.body)
          first_gender = people["1"][2]
          last_response.status.should == 200
          first_gender.should eq("Female")
      end
    end

    describe "GET /people/birthdate" do
      it "sorts folks by date of birth" do
        get "/people/birthdate"
          people = JSON.parse(last_response.body)
          first_birthdate = Date.strptime(people["1"][3], "%m/%d/%Y")
          second_birthdate = Date.strptime(people["2"][3], "%m/%d/%Y")
          last_response.status.should == 200
          (first_birthdate < second_birthdate).should be_true
      end
    end
  end
end


