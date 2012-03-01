require 'dtime/version'
require 'dtime/configuration'
require 'dtime/connection'
require 'dtime/client'

module Dtime
  extend Configuration

  class << self
    # Alias for Dtime::Client.new
    #
    # @return [Dtime::Client]
    def new(options = {})
      Dtime::Client.new(options)
    end

    # Delegate to Dtime::Client
    #
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private = false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end

  end

end # Dtime
