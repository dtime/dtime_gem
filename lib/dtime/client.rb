require 'dtime/oauth_authorization'
require 'dtime/resources/resource_factory'

module Dtime
  # The client is the main interface for making api calls.
  class Client
    include OAuthAuthorization
    include Connection
    include Connection::Request
    extend Forwardable

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
      @current_resource = follow(Dtime::Hypermedia::Link.new(rel: 'root', href: self.endpoint))
    end

    attr_accessor :current_resource

    # Navigates home, returns self for chaining with next call
    def root
      self.home
      self
    end

    # Navigates home, returns self for chaining with next call
    def sitemap
      self.root
      self.follow('dtime:sitemap')
      self.get
      self
    end

    # Navigates home, returns self for chaining with next call
    def dashboard
      self.root
      self.follow('dtime:dashboard')
      self.get
      self
    end

    # Navigates home, returns self for chaining with next call
    def admin_dashboard
      self.root
      self.follow('dtime:dashboard:admin')
      self.get
      self
    end

    # Navigates home, returns self for chaining with next call
    def developer_dashboard
      self.root
      self.follow('dtime:dashboard:developers')
      self.get
      self
    end

    def home
      @current_resource = follow(Dtime::Hypermedia::Link.new(rel: 'root', href: self.endpoint))
      self.get
    end


    #
    # Pass HTTP methods to the current resource
    #
    def_instance_delegators :@current_resource, :get, :post, :options, :head, :put, :delete, :patch, :post_with_file
    #
    # Pass build and template to current resource
    #
    def_instance_delegators :@current_resource, :template, :build

    def follow(rel, opts = {})
      @current_resource = resources.create_for_link(rel, opts)
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
      elsif link = self.link_for_rel(method.to_s)
        self.follow(link, args.first)
      else
        super
      end
    end

  end # Client
end # Dtime
