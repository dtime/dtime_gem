require 'spec_helper'

describe Dtime::Hypermedia::Hal do
  it 'should get nil if empty template' do
    subject.template.should be_nil
  end
  context 'given empty links' do
    subject {
      Dtime::Hypermedia::Hal.new({_links: {}})
    }
    it 'has no links' do
      lambda{
        subject.links
      }.should raise_error(ArgumentError)
    end
  end
  context 'given links' do
    subject {
      Dtime::Hypermedia::Hal.new({_links: {self: {href: 'foobar'}}})
    }
    it 'has self link' do
      subject.link_for('self').should be_a(Dtime::Hypermedia::Link)
    end
  end
  context 'given template' do
    subject {
      Dtime::Hypermedia::Hal.new({_template: {data: []}})
    }
    it 'has a template' do
      subject.template.should be_a(Dtime::Hypermedia::Template)
    end
  end
end
