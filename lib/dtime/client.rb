require 'dtime/oauth_authorization'

module Dtime
  # The client is the main interface for making api calls.
  class Client
    include OAuthAuthorization
    include Connection
    include Connection::Request

    attr_reader *Configuration::VALID_OPTIONS_KEYS

    # Callback to update global configuration options
    # So all options to Dtime::Client pass through to the
    # Dtime global config
    class_eval do
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        define_method "#{key}=" do |arg|
          self.instance_variable_set("@#{key}", arg)
          Dtime.send("#{key}=", arg)
        end
      end
    end

    # Creates new API
    def initialize(options = {})
      options = Dtime.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
      oauth_client if client_id? && client_secret?
    end

    # Responds to attribute query
    def method_missing(method, *args, &block) # :nodoc:
      if method.to_s =~ /^(.*)\?$/
        return !self.send($1.to_s).nil?
      else
        super
      end
    end

  end # Client
end # Dtime
