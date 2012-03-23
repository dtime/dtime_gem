require 'hashie'
require "addressable/template"

module Dtime
  module Hypermedia

    # A link is mostly just a hashie mash
    class Link < ::Hashie::Mash
      def href
        opts = self.fetch('uri_opts', {})
        @template ||= Addressable::Template.new(self.fetch('href'))
        raise ArgumentError.new("Uri options not provided for this template") unless (@template.keys - opts.keys).size == 0
        @template.expand(opts).to_s
      end
      def to_template
        if self.respond_to?('data')
          Dtime::Hypermedia::Template.new(self)
        else
          nil
        end
      end
    end
  end
end
