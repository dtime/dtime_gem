module Dtime
  # Class for handling api configuration options
  # and making them available at Dtime.config
  module Configuration

    VALID_CONFIG_KEYS = [
      :adapter,
      :client_id,
      :client_secret,
      :oauth_token,
      :endpoint,
      :mime_type,
      :user_agent,
      :connection_options,
      :login,
      :password
    ].freeze

    # Other adapters are :typhoeus, :patron, :em_synchrony, :excon, :test
    DEFAULT_ADAPTER = :net_http

    # By default, set to dtime public api
    DEFAULT_CLIENT_ID = '4ee43e9abce748bebf000004'.freeze

    # By default, set to dtime public api
    DEFAULT_CLIENT_SECRET = 'b7eb9457239007ad77b66fb0dd32900027ad1b7eb9457d6fb0dd5412ae'.freeze

    # By default, don't set a user oauth access token
    DEFAULT_OAUTH_TOKEN = nil

    # By default, don't set a user login name
    DEFAULT_LOGIN = nil

    # By default, don't set a user password
    DEFAULT_PASSWORD = nil

    # The endpoint used to connect to Dtime if none is set
    DEFAULT_ENDPOINT = 'https://api.dtime.com'.freeze

    # The value sent in the http header for 'User-Agent' if none is set
    DEFAULT_USER_AGENT = "Dtime Ruby Gem #{Dtime::VERSION}".freeze

    # By default the <tt>Accept</tt> header will make a request for <tt>JSON</tt>
    DEFAULT_MIME_TYPE = :json

    # By default uses the Faraday connection options if none is set
    DEFAULT_CONNECTION_OPTIONS = {}

    attr_accessor *VALID_CONFIG_KEYS

    # Convenience method to allow for global setting of configuration options
    def configure
      yield self
    end

    def self.extended(base)
      base.set_defaults
    end

    def config
      VALID_CONFIG_KEYS.inject({}) { |acc, k| acc[k] = send(k); acc }
    end

    def set_defaults
      self.adapter            = DEFAULT_ADAPTER
      self.client_id          = DEFAULT_CLIENT_ID
      self.client_secret      = DEFAULT_CLIENT_SECRET
      self.oauth_token        = DEFAULT_OAUTH_TOKEN
      self.endpoint           = DEFAULT_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.mime_type          = DEFAULT_MIME_TYPE
      self.login              = DEFAULT_LOGIN
      self.password           = DEFAULT_PASSWORD
      self
    end

  end # Configuration
end # Dtime
