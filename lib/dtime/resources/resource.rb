module Dtime
  module Resources
    class Resource
      attr_accessor :client, :root
      def initialize(client, link)
        @client = client
        if link.respond_to?(:href)
          @root = link
        else
          # Get rel, fetch from index page if necessary
          @root = client.link_for_rel(link, true) if link
        end
      end

      def template
        @template ||= client.options(@root).template
      end


    end
  end
end
