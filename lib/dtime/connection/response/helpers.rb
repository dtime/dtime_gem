require 'faraday'

module Dtime
  module Connection
    # A module for methods that will be available on the faraday body
    module Response::Helpers




      # Faraday middleware to mix the response helpers module
      # into the body
      class Middleware < Faraday::Response::Middleware
        def on_complete(env)
          env[:body].extend(Dtime::Connection::Response::Result)
          env[:body].instance_eval { @env = env }
        end
      end
    end # Response::Helpers
  end
end # Dtime
