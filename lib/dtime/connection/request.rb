require 'dtime/connection/request/oauth2'
require 'dtime/connection/request/basic_auth'

require 'base64'
require 'addressable/uri'
require 'multi_json'

module Dtime
  module Connection
    # Defines HTTP verbs, creating convenience methods for
    # using the connection.
    module Request

      METHODS = [:get, :post, :put, :delete, :patch]
      METHODS_WITH_BODIES = [ :post, :put, :patch ]

      def get(path, params={}, options={})
        request(:get, path, params, options)
      end

      def patch(path, params={}, options={})
        request(:patch, path, params, options)
      end

      def post(path, params={}, options={})
        request(:post, path, params, options)
      end

      def put(path, params={}, options={})
        request(:put, path, params, options)
      end

      def delete(path, params={}, options={})
        request(:delete, path, params, options)
      end

      def request(method, path, params, options)
        if !METHODS.include?(method)
          raise ArgumentError, "unkown http method: #{method}"
        end
        puts "EXECUTED: #{method} - #{path} with #{params} and #{options}"

        response = connection(options).send(method) do |request|
          case method.to_sym
          when *(METHODS - METHODS_WITH_BODIES)
            request.url(path, params)
          when *METHODS_WITH_BODIES
            request.path = path
            request.body = MultiJson.encode(params) unless params.empty?
          end
        end
        response.body
      end

      private

      def basic_auth(login, password) # :nodoc:
        auth = Base64.encode("#{login}:#{password}")
        auth.gsub!("\n", "")
      end

      def token_auth
      end

    end # Request
  end
end # Dtime
