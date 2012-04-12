require 'dtime/resources/users'
require 'dtime/resources/user'
module Dtime
  module Resources
    class ResourceFactory

      attr_accessor :client

      # Create a factory instance for resources
      # Takes a Dtime::Client as an argument
      def initialize(client)
        @client = client
      end


      # Find the link for a given rel from the client's last request
      # Will first try raw rel, then fall back to curie uri prefixed with dtime
      #
      # If rel not found, raises Dtime::UnknownRel
      # Opts, if provided, will be used for a uri template
      def turn_rel_into_link(rel, opts = {})
        return rel if rel.respond_to?(:rel)
        ret = client.link_for_rel(rel, opts.merge(:force => true))
        ret = client.link_for_rel("dtime:#{rel}", opts) unless ret
        raise Dtime::UnknownRel.new("Rel '#{rel}' not recognized", {}) unless ret
        ret
      end

      # Build a resource for querying
      # Takes either a string rel attribute or a
      # link object with rel and href attributes
      #
      # May raise an UnknownRel error if an rel is not defined
      def create_for_link(link, opts = {})
        link = turn_rel_into_link(link, opts)
        rel = link.rel.split.first
        resource = case rel
        when 'user'
          Dtime::Resources::User.new(client, link)
        when 'users'
          Dtime::Resources::Users.new(client, link)
        else
          Dtime::Resources::Resource.new(client, link)
        end
        @last_resource = resource
        resource
      end
    end
  end
end
