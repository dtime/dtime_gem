require 'spec_helper'

describe Dtime::Resources::ResourceFactory do
  before do
    stub_get("/").
      to_return(:body => fixture('index/public.json'),
        :status => 200,
        :headers => {
          :content_type => "application/json; charset=utf-8",
          'X-RateLimit-Remaining' => '4999',
          'content-length' => '344'
        })
  end
  let(:client){ Dtime::Client.new }
  let(:subject) do
    Dtime::Resources::ResourceFactory.new(client)
  end
  let(:user_resource) do
    subject.create_for_link('user')
  end
  let(:users_resource) do
    subject.create_for_link('users')
  end

  it 'can create a subclass for a given rel' do
    user_resource.should be_a(Dtime::Resources::User)
  end
  it 'raises an unknown rel error for arbitrarily random rels' do
    lambda{
      subject.create_for_link('banana')
    }.should raise_error(Dtime::UnknownRel)
  end
end
