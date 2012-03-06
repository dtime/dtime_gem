require 'faraday'
require 'base64'

module Dtime
  module Connection
    module Request
      class BasicAuth < Faraday::Middleware
        dependency 'base64'

        def call(env)
          env[:request_headers].merge!('Authorization' => "Basic #{@auth}\"")

          @app.call env
        end

        def initialize(app, *args)
          @app = app
          credentials = ""
          opts = args.last.is_a?(Hash) ? args.pop : {}
          if opts.has_key? :login
            credentials = "#{opts[:login]}:#{opts[:password]}"
          end
          @auth = Base64.encode64(credentials)
          @auth.gsub!("\n", "")
        end
      end # BasicAuth
    end # Request
  end
end # Dtime
