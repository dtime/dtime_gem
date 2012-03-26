require 'spec_helper'

describe Dtime::Resources::Resource do
  let(:client) do
    Dtime::Client.new
  end
  let(:link) do
    Hashie::Mash.new(href: 'https://api.dtime.com/docs', rel: 'documentation', uri_opts: {})
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
    end
    let(:subject) do
      Dtime::Resources::Resource.new(client, 'users')
    end
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
      it "can't call error build!" do
        lambda{
          subject.build!
        }.should raise_error
      end
      it "can still build if ignore errors" do
        lambda{
          subject.build
        }.should_not raise_error
      end
      it "can still build if ignore errors" do
        subject.build == Hashie::Mash.new
      end
    end
    context 'fetched' do
      before do
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

