require 'hashie'

module Dtime
  module Hypermedia

    # A link is simply a hashie mash
    class Link < ::Hashie::Mash
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
