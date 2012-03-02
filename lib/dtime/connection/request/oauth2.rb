# encoding: utf-8

require 'faraday'

module Dtime
  module Connection
    module Request
      # Middleware to add in OAuth headers based on current
      # user token
      class OAuth2 < Faraday::Middleware
        dependency 'oauth2'

        def call(env)
          env[:request_headers].merge!('Authorization' => "OAuth #{@token}")

          @app.call env
        end

        def initialize(app, *args)
          @app = app
          @token = args.shift
        end
      end # OAuth2
    end # Request
  end
end # Dtime
