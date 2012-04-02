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
        raise ArgumentError.new("I should have a rel self in #{self._links.inspect}") if self._links? && !self.link_for('self')

        # Turn tmpl into template
      end

      def template
        return nil unless self['_template']
        @template ||= Dtime::Hypermedia::Template.new(self['_template'])
        @template
      end


      # Creates a link object for a given rel, or returns nil if
      # one does not exist
      def link_for(rel, opts = {})
        name = opts.delete(:name)
        if l = self[:_links][rel]
          l = l.detect{|lk| lk[:name] == name} if l.is_a?(Array)
          return nil unless l
          l = Dtime::Hypermedia::Link.new(l.merge(rel: rel))
          l.uri_opts = opts
          l
        elsif rel =~ /(.+)\.(.+)/
          if l = self[:_embedded][$1][:_links][$2]
            l = l.detect{|lk| lk[:name] == name} if l.is_a?(Array)
            return nil unless l
            l = Dtime::Hypermedia::Link.new(l.merge(rel: rel))
            l.uri_opts = opts
            l
          end
        end
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
