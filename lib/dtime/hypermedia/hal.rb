require 'hashie'
require 'dtime/hypermedia/link'
require 'dtime/hypermedia/template'

module Dtime
  module Hypermedia

    # Helpers for hal specific response that has been parsed a
    # mash
    #
    # raises ArgumentError if a _links object is passed with a self reference
    class Hal < ::Hashie::Mash
      def initialize(*args)
        super

        # Turn links into links
        self.fetch('_links', {}).each do |k, v|
          self['_links'][k] = Dtime::Hypermedia::Link.new(v.merge(rel: k))
        end

        # It is an argument error to create a hal hash with an empty links array
        raise ArgumentError if self._links? && !self.link_for('self')

        # Turn tmpl into template
      end

      def template
        return nil unless self['_template']
        @template ||= Dtime::Hypermedia::Template.new(self['_template'])
        @template
      end

      def link_for(rel)
        self[:_links][rel]
      end
    end
  end
end
