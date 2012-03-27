require 'faraday'
require 'faraday_middleware'
require 'dtime/connection/response'
require 'dtime/connection/request'

module Dtime

  # The connection is responsible for creating a faraday connection
  # It is used to set up faraday and communicate with the server
  #
  # Connection is included into the Client class.
  module Connection

    attr_accessor :last_response

    # Returns true if a faraday connection stack has been built
    def cached_connection?
      !@connection.nil?
    end

    # Allow a fresh connection to be created next api call
    # Also removes last response
    def clear_cached_connection
      @connection = nil
      @file_connection = nil
      @last_response = nil
    end

  private

    def header_options() # :nodoc:
      {
        :headers => {
          'Accept'       => '*/*', #accepts,
          'User-Agent'   => user_agent
        },
        :ssl => { :verify => false },
        :url => endpoint
      }
    end

    def connection(opts = {}) # :nodoc:

      # parse(options['resource'], options['mime_type'] || mime_type) if options['mime_type']
#       merged_options = if connection_options.empty?
#         header_options.merge(options)
#       else
#         connection_options.merge(header_options)
#       end
      merged_options = header_options.merge(opts)

      clear_cached_connection unless opts.empty?

      @connection ||= begin
        Faraday.new(merged_options) do |builder|
          builder.use Dtime::Connection::Response::RaiseError

          builder.use FaradayMiddleware::ParseJson
          builder.use FaradayMiddleware::EncodeJson
          # builder.use Faraday::Request::Multipart
          # builder.use Faraday::Request::UrlEncoded
          # builder.use Faraday::Response::Logger

          # Dtime::Connection::Response.faraday_build(builder, options)
          builder.use Dtime::Connection::Request::OAuth2, oauth_token if oauth_token?
          builder.use Dtime::Connection::Request::BasicAuth, authentication if basic_authed?

          builder.use Dtime::Connection::Response::Helpers::Middleware
          builder.use Dtime::Connection::Response::Halify

          builder.adapter adapter
        end
      end
      @connection
    end
    def file_connection(opts = {})
      merged_options = header_options.merge(opts)

      # clear_cached_connection unless opts.empty?
      @file_connection ||= begin
        Faraday.new(merged_options) do |builder|
          builder.use Dtime::Connection::Response::RaiseError

          builder.use FaradayMiddleware::ParseJson
          builder.use Dtime::Connection::Response::Helpers::Middleware
          builder.use Dtime::Connection::Response::Halify

          # builder.use FaradayMiddleware::EncodeJson
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          # builder.use Faraday::Response::Logger

          # Dtime::Connection::Response.faraday_build(builder, options)
          builder.use Dtime::Connection::Request::OAuth2, oauth_token if oauth_token?
          builder.use Dtime::Connection::Request::BasicAuth, authentication if basic_authed?


          builder.adapter adapter
        end
      end
      @file_connection
    end

  end # Connection
end # Dtime
