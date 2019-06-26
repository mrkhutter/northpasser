require 'spec_helper'
require 'pry'

describe Northpasser::Request do
  let(:new_northpass) { Northpasser::Northpass.new(ENV['NORTHPASS_API_TOKEN']) }

  describe '.new' do
    before(:example) do
      # Request requires the northpass object to have a path
      new_northpass.clear_path
      new_northpass.courses
    end

    it 'requires a northpass instance' do
      expect { described_class.new(nil, action: :Get) }.to raise_error(ArgumentError)
    end

    it 'requires a known action' do
      expect { described_class.new(new_northpass, action: :foo) }.to raise_error(ArgumentError)
    end

    it 'returns a new northpass::Request object if successful' do
      expect(described_class.new(new_northpass, action: :Get)).to be_a(described_class)
    end
  end

  describe '#fetch' do
    it 'makes the api call' do
      northpass = new_northpass.courses
      req = described_class.new(northpass, action: :Get)

      expect(Net::HTTP).to receive(:start)

      req.fetch
    end

    context 'with, er, some non-exhaustive examples of api calls' do
      it 'lists all courses' do

        courses_response_json = File.new("spec/northpasser/files/sample_courses_list.json")
        WebMock.stub_request(:get, /.*api.northpass.com\/v1\/courses*/)
          .to_return(status: 200, body: courses_response_json.read)
      
        northpass = new_northpass.courses.list

        expect(northpass[:code]).to eq('200')
        datagram = northpass[:content]['data'].first
        expect(datagram['id']).to eq('b685091b-6f65-4c20-9ba8-132b5ffbddde')
        expect(datagram['attributes']['name']).to eq('Design and Market Your School Site')
      end

      it 'gets a course' do
        courses_response_json = File.new("spec/northpasser/files/sample_courses_get.json")
        WebMock.stub_request(:get, /.*api.northpass.com\/v1\/courses*/)
          .to_return(status: 200, body: courses_response_json.read)
        
        northpass = new_northpass.courses.get(id: 'ea210647-aa59-49c1-85d1-5cae0ea6eed0')

        expect(northpass[:code]).to eq('200')
        datagram = northpass[:content]['data']
        expect(datagram['id']).to eq('ea210647-aa59-49c1-85d1-5cae0ea6eed0')
        expect(datagram['attributes']['name']).to eq('Northpass Onboarding')
      end

      it 'creates a learner' do
        learners_response_json = File.new("spec/northpasser/files/sample_learner_create.json")
        WebMock.stub_request(:post, /.*api.northpass.com\/v1\/learners*/)
          .to_return(status: 201, body: learners_response_json.read)
        
        northpass = new_northpass.learners.create(data: { type: 'people', attributes: {email: "api+faraday@northpass.com"} })

        expect(northpass[:code]).to eq('201')
        datagram = northpass[:content]['data']
        expect(datagram['attributes']['email']).to eq('api+faraday@northpass.com')
        expect(datagram['attributes']['unsubscribed']).to eq(false)
      end

      it 'updates a category' do
        categories_response_json = File.new("spec/northpasser/files/sample_category_update.json")
        WebMock.stub_request(:put, /.*api.northpass.com\/v1\/categories*/)
          .to_return(status: 200, body: categories_response_json.read)
        
        northpass = new_northpass.categories.update(id: '8270f668-fab9-4d4c-9008-0c08fa87e2bf', data: {attributes: {name: 'Silly Strings'}})

        expect(northpass[:code]).to eq('200')
        datagram = northpass[:content]['data']
        expect(datagram['attributes']['name']).to eq('Silly Strings')
      end

      it 'deletes a category' do
        WebMock.stub_request(:delete, /.*api.northpass.com\/v1\/categories*/)
          .to_return(status: 204)
 
        northpass = new_northpass.categories.delete(id: 'ac2ae6b6-ab15-41b0-883c-5f536a062689')

        expect(northpass[:code]).to eq('204')
      end

      it 'reports errors for a missing learners' do
         WebMock.stub_request(:get, /.*api.northpass.com\/v1\/courses*/)
          .to_return(status: 404)

        northpass = new_northpass.courses.get(id: 'samiam')

        expect(northpass[:code]).to eq('404')
      end
      
      it 'reports errors for bad params' do
        bad_params = File.new("spec/northpasser/files/bad_params.json")
        WebMock.stub_request(:post, /.*api.northpass.com\/v1\/learners*/)
         .to_return(status: 422, body: bad_params.read)

        northpass = new_northpass.learners.create(data: { foo: 'bar', attributes: {small: "fries"} })
        expect(northpass[:code]).to eq('422')
        expect(northpass[:content].key?("errors")).to be true
      end
    end
  end
end
