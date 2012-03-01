require 'spec_helper'

describe Dtime::OAuthAuthorization do

  let(:client_id) { '234jl23j4l23j4l' }
  let(:client_secret) { 'asasd79sdf9a7asfd7sfd97s' }
  let(:code) { 'c9798sdf97df98ds'}
  let(:dtime) { Dtime.new }

  it "should instantiate oauth2 instance" do
    dtime.oauth_client.should be_a OAuth2::Client
  end

  it "should assign site from the options hash" do
    dtime.oauth_client.site.should == 'https://www.dtime.com'
  end

  it "should assign 'authorize_url" do
    dtime.oauth_client.authorize_url.should == 'https://www.dtime.com/oauth/authorize'
  end

  it "should assign 'token_url" do
    dtime.oauth_client.token_url.should == 'https://www.dtime.com/oauth/access_token'
  end

  context "authorize_url" do
    before do
      dtime = Dtime.new :client_id => client_id, :client_secret => client_secret
    end

    it "should respond to 'authorize_url' " do
      dtime.should respond_to :authorize_url
    end

    it "should return address containing client_id" do
      dtime.authorize_url.should =~ /client_id=#{client_id}/
    end

    it "should return address containing scopes" do
      dtime.authorize_url(:scope => 'user').should =~ /scope=user/
    end

    it "should return address containing redirect_uri" do
      dtime.authorize_url(:redirect_uri => 'http://localhost').should =~ /redirect_uri/
    end
  end

  context "get_token" do
    before do
      dtime = Dtime.new :client_id => client_id, :client_secret => client_secret
      stub_request(:post, 'https://www.dtime.com/oauth/access_token').
        to_return(:body => '', :status => 200, :headers => {})
    end

    it "should respond to 'get_token' " do
      dtime.should respond_to :get_token
    end

    it "should make the authorization request" do
      expect {
        dtime.get_token code
        a_request(:post, "https://www.dtime.com/oauth/access_token").should have_been_made
      }.to raise_error(OAuth2::Error)
    end

    it "should fail to get_token without authorization code" do
      expect { dtime.get_token }.to raise_error(ArgumentError)
    end
  end

  context "get_client_token" do
    before do
      dtime = Dtime.new :client_id => client_id, :client_secret => client_secret
      stub_request(:post, 'https://www.dtime.com/oauth/access_token').
        to_return(:body => '', :status => 200, :headers => {})
    end

    it "should respond to 'get_client_token' " do
      dtime.should respond_to :get_client_token
    end

    it "should make the authorization request" do
      expect {
        dtime.get_client_token
        a_request(:post, "https://www.dtime.com/oauth/access_token").should have_been_made
      }.to raise_error(OAuth2::Error)
    end

  end

  context "authentication" do
    it "should respond to 'authentication'" do
      dtime.should respond_to :authentication
    end

    context 'login & password' do
      before do
        dtime = Dtime.new :login => 'dtime', :password => 'pass'
      end

      it "should return hash with login & password params" do
        dtime.authentication.should be_a Hash
        dtime.authentication.should have_key :login
      end
    end
  end # authentication

end # Dtime::Authorization
