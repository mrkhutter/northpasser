require 'spec_helper'

describe Northpasser::V1 do
  it 'has a version number' do
    expect(Northpasser::V1::VERSION).to_not be nil
  end

  it 'has a FORMATS constant defining acceptable reponse formats' do
    expect(Northpasser::V1::FORMATS).to_not be nil
  end

  it 'has an ACTIONS constant defining acceptable request actions' do
    expect(Northpasser::V1::ACTIONS).to_not be nil
  end

  it 'has a RESOURCES constant defining known api resources' do
    expect(Northpasser::V1::RESOURCES).to_not be nil
  end

  it 'has an annoying EXCEPTIONS constant defining known api exceptions' do
    expect(Northpasser::V1::EXCEPTIONS).to_not be nil
  end

  it 'has an API_URL constant defining the base api url' do
    expect(Northpasser::V1::V1_API_URL).to_not be nil
  end
end
