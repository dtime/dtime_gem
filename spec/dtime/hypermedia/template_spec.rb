require 'spec_helper'

describe Dtime::Hypermedia::Template do
  context 'given template' do
    subject {
      Dtime::Hypermedia::Template.new({data: []})
    }
    it 'fields should be empty for new template' do
      subject.fields.should == []
    end
    it 'has a template' do
      subject.should be_a(Hash)
    end
    it 'has a build' do
      subject.build.should be_a(Dtime::Hypermedia::BuildObject)
    end
  end
  context 'given invalid template' do
    subject {
      Dtime::Hypermedia::Template.new({})
    }
    it "has an empty fieldset" do
      subject.fields == []
    end
    it "builds an empty build object" do
      subject.build == {}
    end
  end
end
