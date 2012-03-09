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
        Dtime::Hypermedia::Link.new(self[:_links][rel].merge(rel: rel)) if self[:_links][rel]
      end



      # The body of a result should be wrapped into a result object.
      # If it is and the requested key is defined in it,
      # we pass any method missing on to result
      def method_missing(name, *args)
        if self.has_key?(name)
          super
        elsif self.has_key?(:result) && self[:result].respond_to?(:has_key?) && self[:result].has_key?(name)
          self[:result].send(name, *args)
        else
          super
        end
      end
    end
  end
end
