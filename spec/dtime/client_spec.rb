require 'spec_helper'

describe Dtime::Client do
  it 'has a resource factory' do
    subject.resources.should be_a(Dtime::Resources::ResourceFactory)
  end
end
