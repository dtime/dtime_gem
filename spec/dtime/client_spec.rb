require 'spec_helper'

describe Dtime::Client do
  it 'has a resource factory' do
    subject.resources.should be_a(Dtime::Resources::ResourceFactory)
  end
  it 'has a current resource' do
    subject.current_resource.should be_a(Dtime::Resources::Resource)
  end
  let(:mocked){ double(:resource) }
  %w(get post put patch options head delete).each do |w|
    it "delegates #{w} to current resource" do
      mocked.should_receive(w.to_sym)
      subject.current_resource = mocked
      subject.send(w.to_sym)
    end
  end
end
