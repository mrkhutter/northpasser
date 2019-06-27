require 'spec_helper'
require 'pry'

describe Northpasser::Request do
  let(:new_northpass) { Northpasser::Northpass.new(ENV['NORTHPASS_API_TOKEN']) }

  describe '.new' do
    before(:example) do
      # Request requires the northpass object to have a path
      new_northpass.clear_path
      new_northpass.activities
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
      northpass = new_northpass.activities
      req = described_class.new(northpass, action: :Get)

      expect(Net::HTTP).to receive(:start)

      req.fetch
    end

    context 'with, er, some non-exhaustive examples of api calls' do
      it 'lists all activities' do

        activities_response_json = File.new("spec/northpasser/files/sample_activities_list.json")
        WebMock.stub_request(:get, /.*api.northpass.com\/v2\/activities*/)
          .to_return(status: 200, body: activities_response_json.read)
        
        northpass = new_northpass.activities.list

        expect(northpass[:code]).to eq('200')
        datagram = northpass[:content]['data'].first
        expect(datagram['id']).to eq('a5537258-0873-4da3-98c2-805d7d31a23d')
        expect(datagram['attributes']['title']).to eq('Optimal price point')
      end

      it 'gets an activity' do
        activity_response_json = File.new("spec/northpasser/files/sample_activity_get.json")
        WebMock.stub_request(:get, /.*api.northpass.com\/v2\/activities*/)
          .to_return(status: 200, body: activity_response_json.read)
        
        northpass = new_northpass.activities.get(id: 'b21fe6b7-8f2b-40e8-a058-f00f1a53e2b5')

        expect(northpass[:code]).to eq('200')
        datagram = northpass[:content]['data']
        expect(datagram['id']).to eq('b21fe6b7-8f2b-40e8-a058-f00f1a53e2b5')
        expect(datagram['attributes']['title']).to eq('Welcome to Northpass')
      end

      it 'creates a person' do
        person_response_json = File.new("spec/northpasser/files/sample_person_create.json")
        WebMock.stub_request(:post, /.*api.northpass.com\/v2\/people*/)
          .to_return(status: 201, body: person_response_json.read)
        
        northpass = new_northpass.people.create(data: { type: 'people', attributes: {email: "api+faraday@northpass.com"} })

        expect(northpass[:code]).to eq('201')
        datagram = northpass[:content]['data']
        expect(datagram['attributes']['email']).to eq('api+faraday@northpass.com')
        expect(datagram['attributes']['unsubscribed']).to eq(false)
      end

      it 'reports errors for a missing people' do
         WebMock.stub_request(:get, /.*api.northpass.com\/v2\/people*/)
          .to_return(status: 404)

        northpass = new_northpass.people.get(id: 'samiam')

        expect(northpass[:code]).to eq('404')
      end
      
      it 'reports errors for bad params' do
        bad_params = File.new("spec/northpasser/files/bad_params.json")
        WebMock.stub_request(:post, /.*api.northpass.com\/v2\/events*/)
         .to_return(status: 422, body: bad_params.read)

        northpass = new_northpass.events.create(data: { foo: 'bar', attributes: {small: "fries"} })
        expect(northpass[:code]).to eq('422')
        expect(northpass[:content].key?("errors")).to be true
      end
    end
  end
end
