# encoding: utf-8

require 'faraday'
require 'dtime/hypermedia/hal'

module Dtime
  module Connection
    module Response
      class Halify< Faraday::Response::Middleware
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
