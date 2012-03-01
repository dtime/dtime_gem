require 'faraday'
require 'dtime/connection/response'
require 'dtime/connection/request'

module Dtime

  # The connection is responsible for creating a faraday connection
  # It is used to set up faraday and communicate with the server
  #
  # Connection is included into the Client class.
  module Connection

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

    def clear_cache # :nodoc:
      @connection = nil
    end

    def caching? # :nodoc:
      !@connection.nil?
    end

    def connection(options = {}) # :nodoc:

      # parse(options['resource'], options['mime_type'] || mime_type) if options['mime_type']
#       merged_options = if connection_options.empty?
#         header_options.merge(options)
#       else
#         connection_options.merge(header_options)
#       end
      merged_options = header_options.merge(options)

      clear_cache unless options.empty?

      @connection ||= begin
        Faraday.new(merged_options) do |builder|

          puts options.inspect

          builder.use Faraday::Request::JSON
          builder.use Faraday::Request::Multipart
          builder.use Faraday::Request::UrlEncoded
          builder.use Faraday::Response::Logger

          # Dtime::Connection::Response.faraday_build(builder, options)
          builder.use Dtime::Connection::Request::OAuth2, oauth_token if oauth_token?
          builder.use Dtime::Connection::Request::BasicAuth, authentication if basic_authed?

          builder.use Dtime::Connection::Response::Helpers::Middleware
          builder.use Dtime::Connection::Response::Mashify
          builder.use Dtime::Connection::Response::Jsonize

          builder.use Dtime::Connection::Response::RaiseError
          builder.adapter adapter
        end
      end
    end

  end # Connection
end # Dtime
