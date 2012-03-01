# encoding: utf-8

require 'faraday'

module Dtime
  module Connection
    module Response
      class Jsonize < Faraday::Response::Middleware
        dependency 'multi_json'

        def parse(body)
          case body
          when ''
            nil
          when 'true'
            true
          when 'false'
            false
          else
            ::MultiJson.decode body
          end
        end
      end # Response::Jsonize
    end
  end
end # Dtime
