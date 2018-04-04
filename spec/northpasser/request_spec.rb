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
      it 'lists all courses', :vcr do
        northpass = new_northpass.courses.list

        expect(northpass[:code]).to eq('200')
        expect(northpass[:status]).to eq('OK')
        datagram = northpass[:content]['data'].first
        expect(datagram['id']).to eq('72673479-ad0c-4e81-bb2f-47174ff09396')
        expect(datagram['attributes']['name']).to eq('Getting Started with Pixel (Sample Course)')
      end

      it 'gets a course', :vcr do
        northpass = new_northpass.courses.get(id: '11790b45-3b0c-4105-ab91-b4b3e35c53c7')

        expect(northpass[:code]).to eq('200')
        expect(northpass[:status]).to eq('OK')
        datagram = northpass[:content]['data']
        expect(datagram['id']).to eq('11790b45-3b0c-4105-ab91-b4b3e35c53c7')
        expect(datagram['attributes']['name']).to eq('Scheduling')
      end

      it 'creates a learner', :vcr do
        northpass = new_northpass.learners.create(type: 'people', attributes: {email: "something@shipt.com"} )

        expect(northpass[:code]).to eq('201')
        expect(northpass[:status]).to eq('Created')
        datagram = northpass[:content]['data']
        expect(datagram['attributes']['email']).to eq('something@shipt.com')
        expect(datagram['attributes']['unsubscribed']).to eq(false)
      end

      xit 'updates a category', :vcr do
      end

      xit 'deletes a category', :vcr do
      end

      xit 'reports errors for a missing learners', :vcr do
      end
      
      xit 'reports errors for bad params', :vcr do
      end
    end
  end
end
