require 'dtime/resources/user'
require 'dtime/resources/users'
module Dtime
  module Resources
    class ResourceFactory
      attr_accessor :client
      def initialize(client)
        @client = client
      end
      def create_for_link(link)
        rel = link
        if rel.respond_to?(:rel)
          rel = link.rel
        end
        case rel
        when 'user'
          Dtime::Resources::User.new(client, link)
        when 'users'
          Dtime::Resources::Users.new(client, link)
        else
          self.new(link, client)
        end
      end
    end
  end
end
