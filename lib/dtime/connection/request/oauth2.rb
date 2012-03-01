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
          puts "ENV: #{env.inspect}"
          puts "TOKEN : #{@token}"
          puts "APP: #{@app}"

          # Extract parameters from the query
          params = env[:url].query_values || {}

          env[:url].query_values = { 'oauth_token' => @token }.merge(params)

          token = env[:url].query_values['oauth_token']

          env[:request_headers].merge!('Authorization' => "OAuth #{token}")

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
