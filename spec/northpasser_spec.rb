require 'spec_helper'

describe Northpasser do
  it 'has a version number' do
    expect(Northpasser::VERSION).to_not be nil
  end

  it 'has a FORMATS constant defining acceptable reponse formats' do
    expect(Northpasser::FORMATS).to_not be nil
  end

  it 'has an ACTIONS constant defining acceptable request actions' do
    expect(Northpasser::ACTIONS).to_not be nil
  end

  it 'has a RESOURCES constant defining known api resources' do
    expect(Northpasser::V1_RESOURCES).to_not be nil
  end
  
  it 'has a RESOURCES constant defining known api resources' do
    expect(Northpasser::V2_RESOURCES).to_not be nil
  end

  it 'has an annoying EXCEPTIONS constant defining known api exceptions' do
    expect(Northpasser::EXCEPTIONS).to_not be nil
  end

  it 'has an API_URL constant defining the base api url' do
    expect(Northpasser::V1_API_URL).to_not be nil
  end
end
