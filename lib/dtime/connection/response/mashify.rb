require 'faraday'

module Dtime
  module Connection
    class Response::Mashify < Faraday::Response::Middleware
      dependency 'hashie/mash'

      def mash(item)
        ::Hashie::Mash.new item
      end

      def parse(body)
        case body
        when Hash
          mash(body)
        when Array
          body.map { |item| item.is_a?(Hash) ? mash(item) : item }
        else
          body
        end
      end
    end
  end # Response::Mashify
end # Dtime
