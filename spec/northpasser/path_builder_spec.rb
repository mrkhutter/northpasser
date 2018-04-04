require 'spec_helper'

describe Northpasser::PathBuilder do
  let(:new_northpass) { Northpasser::Northpass.new(ENV['API_TOKEN']) }

  # since not every example results in an action, we need to clean the path 
  before(:example) do
    new_northpass.clear_path
  end

  it 'allows you to build a path to a known resource' do
    resource = Northpasser::RESOURCES.sample
    northpass = new_northpass.send(resource)

    expect(northpass).to be_a(Northpass::northpass)
    expect(northpass.path).to eq([resource])
  end

  it 'allows you to add an id to a nested resources parent' do
    resource = Northpasser::RESOURCES.sample
    id = rand(10000)
    northpass = new_northpass.send(resource, id)

    expect(northpass).to be_a(Northpass::northpass)
    expect(northpass.path).to eq([resource, id])
  end

  it 'allows you to clear a partially built path' do
    resource = Northpasser::RESOURCES.sample
    northpass = new_northpass.send(resource)
    northpass.clear_path

    expect(northpass.path).to eq([])
  end

  it 'recognizes and executes known actions, clearing the path' do
    resource = Northpasser::RESOURCES.sample
    action = Northpasser::ACTIONS.keys.sample
    northpass = new_northpass.send(resource)

    expect(Net::HTTP).to receive(:start)

    northpass.send(action)

    expect(northpass.path).to eq([])
  end

  it 'recognizes known exceptions, builds the path, then executes' do
    resource = Northpasser::RESOURCES.sample
    exception = Northpasser::EXCEPTIONS.keys.sample
    northpass = new_northpass.send(resource)

    expect(Net::HTTP).to receive(:start)

    northpass.send(exception)

    expect(northpass.path).to eq([])
  end

  it 'responds to known actions' do
    action = Northpasser::ACTIONS.keys.sample

    expect(new_northpass.respond_to?(action)).to be true
  end

  it 'responds to known resources' do
    resource = Northpasser::RESOURCES.sample
    expect(new_northpass.respond_to?(resource)).to be true
  end

  it 'responds to known exceptions' do
    resource = Northpasser::EXCEPTIONS.keys.sample
    expect(new_northpass.respond_to?(resource)).to be true
  end

  it 'raises an ArgumentError for unrecognized paths' do
    expect { new_northpass.send(:foo) }.to raise_error(NoMethodError)
  end
end
