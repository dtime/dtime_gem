require 'spec_helper'

describe Dtime::Connection::Request do

  let(:dtime) { Dtime.new }
  before do
    stub_get("/").
      to_return(:body => fixture('index/public.json'),
        :status => 200,
        :headers => {
          :content_type => "application/json; charset=utf-8",
          'X-RateLimit-Remaining' => '4999',
          'content-length' => '344'
        })
    stub_get("/user").
      to_return(:body => fixture('users/user.json'),
        :status => 200,
        :headers => {
          :content_type => "application/json; charset=utf-8",
          'X-RateLimit-Remaining' => '4999',
          'content-length' => '344'
        })
  end

  %w(head put post get delete patch options).each do |i|
    it "responds to #{i}" do
      dtime.should respond_to(i)
    end
  end

  it 'can return a url for a given link object' do
    dtime.get_path_for(Hashie::Mash.new(href: '/')).should == '/'
  end

  it 'can return a url for a given rel' do
    dtime.get_path_for('/').should == '/'
  end

  context "fresh request" do
    it "has no last response" do
      dtime.last_response.should be_nil
    end
    it "will get the index for link objects if forced" do
      link = dtime.link_for_rel('user', true)
      dtime.last_response.should_not be_nil
      link.href.should =~ %r{/user$}
    end

  end


  context "second request" do
    before { dtime.get('/') }
    it "sets the last response" do
      dtime.last_response.should_not be_nil
    end
    it "has a link_for(rel) method" do
      dtime.link_for_rel('documentation').href.should =~ /\/docs$/
      dtime.link_for_rel('user').href.should =~ /\/user$/
    end
    it "can use rel to drive next response" do
      lambda{
        dtime.get('user')
      }.should_not raise_error
    end
    it "can use a link object to drive next response" do
      lambda{
        dtime.get(dtime.link_for_rel('user'))
      }.should_not raise_error
    end
  end
end # Dtime::Connection::Request spec
