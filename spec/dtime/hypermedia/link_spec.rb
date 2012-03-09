require 'spec_helper'

describe Dtime::Hypermedia::Link do
  context 'with data template' do
    subject {
      Dtime::Hypermedia::Link.new({rel: 'self', href: 'http://www.example.com', data: []})
    }
    it 'has a template' do
      subject.to_template.should be_a(Dtime::Hypermedia::Template)
    end
  end
  context 'given invalid template' do
    subject {
      Dtime::Hypermedia::Link.new({})
    }
    it "doesn't have a template" do
      subject.to_template.should be_nil
    end
  end
end
