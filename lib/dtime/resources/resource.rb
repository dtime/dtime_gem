module Dtime
  module Resources
    class Resource
      attr_accessor :client, :root, :response
      def initialize(client, link, response = nil)
        @client = client
        if link.respond_to?(:href)
          @root = link
        else
          # Get rel, fetch from index page if necessary
          @root = client.link_for_rel(link, true) if link
        end
        if response
          @response = response
        end
      end


      # Get may raise a 404
      def get
        @response = client.get(@root)
      end
      def options
        @response = client.options(@root)
      end



      def template(force = false)
        # Template can be included in a link for easier access
        @template ||= @root.to_template
        return @template if @template

        options if force
        @template = @response.template if @response
        @template
      end

      def can_build?
        !!template
      end

      def build(*args)
        raise Dtime::NoTemplate.new("Can't build without a template") unless can_build?
        template.build(*args)
      end

      # May raise a 422 - unprocessable
      #
      def post(*args)
        object = build(*args)
        object.validate!
        client.post(@root, object)
      end

    end
  end
end
