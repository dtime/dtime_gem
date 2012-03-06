require 'dtime/oauth_authorization'
require 'dtime/resources/resource_factory'

module Dtime
  # The client is the main interface for making api calls.
  class Client
    include OAuthAuthorization
    include Connection
    include Connection::Request

    attr_reader *Configuration::VALID_CONFIG_KEYS

    # Callback to update global configuration options
    # So all options to Dtime::Client pass through to the
    # Dtime global config
    class_eval do
      Configuration::VALID_CONFIG_KEYS.each do |key|
        define_method "#{key}=" do |arg|
          self.instance_variable_set("@#{key}", arg)
          Dtime.send("#{key}=", arg)
        end
      end
    end

    # Creates new API
    def initialize(opts = {})
      opts = Dtime.config.merge(opts)
      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=",   opts[key])
      end
      oauth_client if client_id? && client_secret?
    end

    def user
      resources.create_for_link('user')
    end

    def users
      resources.create_for_link('users')
    end

    def resources
      @factory ||= Resources::ResourceFactory.new(self)
    end

    # Setting oauth token should clear cached connection
    def oauth_token=(t)
      self.clear_cached_connection if self.cached_connection?
      @oauth_token = t
    end

    # Check config variables for nil if method missing is attribute
    # with question mark
    def method_missing(method, *args, &block)
      if method.to_s =~ /^(.*)\?$/
        return !self.send($1.to_s).nil?
      else
        super
      end
    end

  end # Client
end # Dtime
