require 'faraday'

module Dtime
  module Connection
    # A module for methods that will be available on the faraday body
    module Response
      module Helpers

        RATELIMIT = 'X-RateLimit-Remaining'.freeze
        CONTENT_TYPE = 'Content-Type'.freeze
        CONTENT_LENGTH = 'content-length'.freeze

        attr_reader :env

        # Requests are limited to API v3 to 5000 per hour.
        def ratelimit
          loaded? ? @env[:response_headers][RATELIMIT] : nil
        end

        def content_type
          loaded? ? @env[:response_headers][CONTENT_TYPE] : nil
        end

        def content_length
          loaded? ? @env[:response_headers][CONTENT_LENGTH] : nil
        end

        def status
          loaded? ? @env[:status] : nil
        end

        def success?
          (200..299).include? status
        end

        def body
          loaded? ? @env[:body] : nil
        end

        def link_for(rel)
          loaded? ?
            @env[:body][:links].detect{|l| l["rel"] == rel} : nil
        end

        def loaded?
          !!env
        end



        # Faraday middleware to mix the response helpers module
        # into the body
        class Middleware < Faraday::Response::Middleware
          def on_complete(env)
            env[:body].extend(Dtime::Connection::Response::Helpers)
            env[:body].instance_eval { @env = env }
          end
        end
      end
    end # Response::Helpers
  end
end # Dtime
