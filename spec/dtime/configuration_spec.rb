require 'spec_helper'

describe Dtime::Configuration do

  let(:client_id) { '234jl23j4l23j4l' }
  let(:client_secret) { 'asasd79sdf9a7asfd7sfd97s' }
  let(:code) { 'c9798sdf97df98ds'}
  let(:dtime) { Dtime.new }

  context "has connected" do
    before do
      @dtime = Dtime.new :client_id => client_id, :client_secret => client_secret
      stub_get('/').
        to_return(:body => '', :status => 200, :headers => {})
      @dtime.get
    end

    it "have a cached connection " do
      @dtime.should be_cached_connection
    end
    it "allow setting caching_options" do
      @dtime.caching_options = {}
    end

    it "resets cached connection when oauth_token changed" do
      @dtime.oauth_token = 'foobar'
      @dtime.should_not be_cached_connection
    end
  end

end
