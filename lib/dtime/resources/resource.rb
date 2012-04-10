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
          @root = client.link_for_rel(link, force: true) if link
        end
        if response
          @response = response
        end
      end

      def follow(*args)
        self.options
        client.follow(*args)
      end


      # Get may raise a 404
      def get
        @response = client._get(@root)
        self
      end

      def result
        @response.result if @response
        if @reponse && @response.respond_to?(:result)
          @response.result  ? @response.result : @response
        else
          @response
        end
      end

      def get_result
        self.get unless @response
        self.result
      end

      def options
        @response = client._options(@root)
        self
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

      # Builds with clientside validation enabled. Raises error
      # if clientside template not available
      def build!(*args)
        raise Dtime::NoTemplate.new("Can't build without a template") unless can_build?
        build(*args)
      end

      # Builds without needing a clientside template
      def build(*args)
        if can_build?
          template.build(*args)
        else
          Hashie::Mash.new(*args)
        end
      end

      # Posts without clientside validation
      # May raise a 422 - unprocessable
      #
      def post(*args)
        object = build(*args)
        @response = client._post(@root, object)
        self
      end
      def delete(*args)
        @response = client._delete(@root)
        self
      end
      def put(*args)
        object = build(*args)
        @response = client._put(@root, object)
        self
      end



      # Posts without clientside validation
      # May raise a 422 - unprocessable
      #
      def post_with_file(*args)
        @response = client._post_file(@root, args.first)
        self
      end

      # Posts with clientside validation
      # May raise a 422 - unprocessable
      # May raise TemplateMismatch if clientside template validation error
      #
      # May raise NoTemplate if no template for clientside validation
      def post!(*args)
        object = build!(*args)
        object.validate!
        @response = client._post(@root, object)
        self
      end

    end
  end
end
