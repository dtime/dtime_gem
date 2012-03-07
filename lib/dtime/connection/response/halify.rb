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
              body = ::MultiJson.decode(body)
              Dtime::Hypermedia::Hal.new(body)
            else
              Dtime::Hypermedia::Hal.new({result: ''})
            end
          end
        end
      end # Response::Jsonize
    end
  end
end # Dtime
