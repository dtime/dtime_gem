# encoding: utf-8

require 'faraday'
require 'faraday_middleware/response_middleware'
require 'dtime/hypermedia/hal'

module Dtime
  module Connection
    module Response
      class Halify< FaradayMiddleware::ResponseMiddleware
        dependency 'multi_json'

        def parse(body)
          case body
          when ''
            Dtime::Hypermedia::Hal.new({result: ''})
          when 'true'
            Dtime::Hypermedia::Hal.new({result: true})
          when 'false'
            Dtime::Hypermedia::Hal.new({result: false})
          else
            if body
              begin
                body = ::MultiJson.decode(body)
                Dtime::Hypermedia::Hal.new(body)
              rescue MultiJson::DecodeError => e
                warn "Decode error"
                Dtime::Hypermedia::Hal.new(result: body)
              end
            else
              Dtime::Hypermedia::Hal.new({result: ''})
            end
          end
        end
      end # Response::Jsonize
    end
  end
end # Dtime
