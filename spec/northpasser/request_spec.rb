require 'spec_helper'

describe Northpasser::Request do
  let(:new_northpass) { Northpasser::Northpass.new(ENV['API_TOKEN']) }

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
        expect(northpass[:content].first['id']).to eq(6)
        expect(northpass[:content].first['name']).to eq('An Odyssian Epic')
        expect(northpass[:content].last['id']).to eq(24)
        expect(northpass[:content].last['name']).to eq('My New Epic')
      end

      it 'gets an epic', :vcr do
        northpass = new_northpass.courses.get(id: 6)

        expect(northpass[:code]).to eq('200')
        expect(northpass[:status]).to eq('OK')
        expect(northpass[:content]['id']).to eq(6)
        expect(northpass[:content]['name']).to eq('An Odyssian Epic')
      end

      it 'creates an epic', :vcr do
        northpass = new_northpass.courses.create(name: 'EEEEEEPIC', state: 'to do')

        expect(northpass[:code]).to eq('201')
        expect(northpass[:status]).to eq('Created')
        expect(northpass[:content]['id']).to eq(25)
        expect(northpass[:content]['name']).to eq('EEEEEEPIC')
        expect(northpass[:content]['state']).to eq('to do')
      end

      it 'updates an epic', :vcr do
        northpass = new_northpass.courses.update(id: 6, state: 'in progress')

        expect(northpass[:code]).to eq('200')
        expect(northpass[:status]).to eq('OK')
        expect(northpass[:content]['state']).to eq('in progress')
      end

      it 'deletes an epic', :vcr do
        northpass = new_northpass.courses.delete(id: 6)

        expect(northpass[:code]).to eq('204')
        expect(northpass[:status]).to eq('No Content')
      end

      it 'reports errors for a missing epic', :vcr do
        northpass = new_northpass.courses.get(id: 666)

        expect(northpass[:code]).to eq('404')
        expect(northpass[:status]).to eq('Not Found')
        expect(northpass[:content]).to eq('Resource not found.')
      end

      it 'reports errors for bad params', :vcr do
        northpass = new_northpass.courses.create(foo: 'bar')

        expect(northpass[:code]).to eq('400')
        expect(northpass[:status]).to eq('Bad Request')
        expect(northpass[:content].key?("message")).to be true
        expect(northpass[:content].key?("errors")).to be true
      end

      it 'gets a project', :vcr do
        northpass = new_northpass.projects.get(id: 5)

        expect(northpass[:code]).to eq('200')
        expect(northpass[:status]).to eq('OK')
        expect(northpass[:content]['id']).to eq(5)
        expect(northpass[:content]['name']).to eq('Sweet Project')
      end

      it 'lists all stories for a project', :vcr do
        northpass = new_northpass.projects(5).stories.list

        expect(northpass[:code]).to eq('200')
        expect(northpass[:status]).to eq('OK')
        expect(northpass[:content].count).to eq(3)
        expect(northpass[:content].first['id']).to eq(20)
        expect(northpass[:content].first['name']).to eq('Reap Rewards')
      end

      it 'creates multiple stories', :vcr do
        new_stories = [
          { project_id: 5, name: "Once Upon" },
          { project_id: 5, name: "A Time" },
          { project_id: 5, name: "In A Land" }
        ]
        northpass = new_northpass.stories.bulk_create(stories: new_stories)

        expect(northpass[:code]).to eq('201')
        expect(northpass[:status]).to eq('Created')
        expect(northpass[:content].count).to eq(3)
        expect(northpass[:content].first['id']).to eq(26)
        expect(northpass[:content].first['name']).to eq('Once Upon')
      end

      it 'updates multiple stories', :vcr do
        params = {
          story_ids: [29, 30],
          archived: true
        }
        northpass = new_northpass.stories.bulk_update(params)

        expect(northpass[:code]).to eq('200')
        expect(northpass[:status]).to eq('OK')
        expect(northpass[:content].count).to eq(2)
        expect(northpass[:content].first['id']).to eq(29)
        expect(northpass[:content].first['archived']).to eq(true)
      end

      it 'searches through stories', :vcr do
        northpass = new_northpass.stories.search(text: "In A Land")

        expect(northpass[:code]).to eq('201')
        expect(northpass[:status]).to eq('Created')
        expect(northpass[:content].count).to eq(1)
        expect(northpass[:content].first['id']).to eq(28)
      end
    end
  end
end
