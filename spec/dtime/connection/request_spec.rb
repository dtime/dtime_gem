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

  describe "fresh request" do
    it "has no last response" do
      dtime.last_response.should be_nil
    end

  end

  describe "second request" do
    before { dtime.get('/') }
    it "sets the last response" do
      dtime.last_response.should_not be_nil
    end
    it "has a link_for(rel) method" do
      dtime.last_response.link_for('documentation').href.should =~ /\/docs$/
      dtime.last_response.link_for('user').href.should =~ /\/user$/
    end
    it "can use rel to drive next response" do
      lambda{
        dtime.get('user')
      }.should_not raise_error
    end
  end
end # Dtime::Connection::Request spec
