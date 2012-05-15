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
  context 'with uri template and no uri_opts' do
    subject {
      Dtime::Hypermedia::Link.new({rel: 'self', "href-template" => 'http://www.example.com/{user_id}'})
    }
    it 'raises error on href' do
      lambda{ subject.href }.should raise_error
    end
  end
  context 'with uri template and no uri_opts' do
    subject {
      Dtime::Hypermedia::Link.new({rel: 'self', href: 'http://www.example.com/{user_id}'})
    }
    it 'raises error on href' do
      lambda{ subject.href }.should raise_error
    end
  end
  context 'with uri template and uri_opts' do
    subject {
      Dtime::Hypermedia::Link.new({rel: 'self', "href-template" => 'http://www.example.com/{user_id}/{banana}', uri_opts: {'user_id' => 'foo', :banana => 'bar'}})
    }
    it 'returns href' do
      subject.href.should == 'http://www.example.com/foo/bar'
    end
  end
  context 'with uri template and uri_opts' do
    subject {
      Dtime::Hypermedia::Link.new({rel: 'self', href: 'http://www.example.com/{user_id}/{banana}', uri_opts: {'user_id' => 'foo', :banana => 'bar'}})
    }
    it 'returns href' do
      subject.href.should == 'http://www.example.com/foo/bar'
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
