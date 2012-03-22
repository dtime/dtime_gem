require 'spec_helper'

describe Dtime::Resources::Users do
  let(:client) do
    Dtime::Client.new
  end
  let(:user_hash) do
    {email: "example@example.com", password:'123', password_confirmation:'123', username:'foobar'}
  end
  let(:user_build) do
    subject.build(user_hash)
  end
  describe 'with a template' do
    before do
      stub_get("/").
        to_return(:body => fixture('index/trusted.json'),
          :status => 200,
          :headers => {
            :content_type => "application/json; charset=utf-8"
          })
      stub_opts("/users").
        to_return(:body => fixture('users/index.json'),
          :status => 200,
          :headers => {
            :content_type => "application/json; charset=utf-8"
          })
      client.get
    end
    subject { Dtime::Resources::Resource.new(client, 'users') }


    let(:expected_build) do
      Hashie::Mash.new({email: nil, password:nil, password_confirmation:nil, username:nil})
    end
    context 'unfetched' do
      it 'has no template because unfetched' do
        subject.template.should be_nil
      end
      it 'can force a template fetch' do
        subject.template(true).should be_a(Dtime::Hypermedia::Template)
      end
      it "can't build" do
        subject.should_not be_can_build
      end
    end
    context 'fetched' do
      before do
        stub_post("/users").
          to_return(:body => fixture('users/user.json'),
            :status => 201,
            :headers => {
              :content_type => "application/json; charset=utf-8"
            })
        stub_get("/users").
          to_return(:body => fixture('users/index.json'),
            :status => 200,
            :headers => {
              :content_type => "application/json; charset=utf-8"
            })
        subject.get
      end
      it 'can build' do
        subject.should be_can_build
      end
      it 'shows a simple object' do
        subject.build.should == expected_build
      end
      it 'can build an object' do
        subject.build()
      end
      it "can't post a blank object" do
        lambda{
          subject.post!
        }.should raise_error(Dtime::TemplateMismatch)
      end
      it "can doesn't raise blank error" do
        lambda{
          subject.post
        }.should_not raise_error(Dtime::TemplateMismatch)
      end
      it "can post a hash" do
        lambda{
          subject.post!(user_hash)
        }.should_not raise_error
      end
      it "can post a previously built object" do
        lambda{
          subject.post(user_build)
        }.should_not raise_error
      end
    end
  end
end

