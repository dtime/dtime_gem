require 'spec_helper'

describe Dtime::Resources::Resource do
  let(:client) do
    Dtime::Client.new
  end
  let(:link) do
    Hashie::Mash.new(href: 'https://api.dtime.com/docs', rel: 'documentation')
  end
  describe 'with a non-existent rel' do
    before do
      stub_get("/").
        to_return(:body => fixture('index/public.json'),
          :status => 200,
          :headers => {
            :content_type => "application/json; charset=utf-8"
          })
    end
    let(:subject) do
      Dtime::Resources::Resource.new(client, 'foobar')
    end
    it 'has no root' do
      subject.root.should be_nil
    end
  end
  describe 'with a real rel' do
    before do
      stub_get("/").
        to_return(:body => fixture('index/public.json'),
          :status => 200,
          :headers => {
            :content_type => "application/json; charset=utf-8"
          })
    end
    let(:subject) do
      Dtime::Resources::Resource.new(client, 'documentation')
    end
    it 'has a root' do
      subject.root.should == link
    end
  end
  describe 'with an already defined link' do
    let(:subject) do
      Dtime::Resources::Resource.new(client, link)
    end
    it 'has a root' do
      subject.root.should == link
    end
  end



end

