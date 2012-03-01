module Dtime
  # The OAuthAuthorization module handles configuring the OAuth2 gem
  # and gives convenience methods for interacting with the API authorization
  # endpoint
  module OAuthAuthorization

    attr_accessor :scopes
    attr_accessor :client_endpoint

    # Setup OAuth2 instance
    def oauth_client(endpoint = "https://www.dtime.com")
      @client_endpoint ||= endpoint
      @oauth_client ||= ::OAuth2::Client.new(client_id, client_secret,
        :site          => @client_endpoint,
        :authorize_url => 'oauth/authorize',
        :token_url     => 'oauth/access_token',
        :ssl=> {
          :verify => false
        }
      )
    end


    # Strategy token
    def auth_code
      _verify_client
      oauth_client.auth_code
    end


    # Sends authorization request to dtime.
    # = Parameters
    # * <tt>:redirect_uri</tt> - Required string.
    # * <tt>:endpoint</tt> - Optional string. Set the dtime oauth endpoint.
    # * <tt>:scope</tt> - Optional string. Comma separated list of scopes.
    #   Available scopes:
    #
    def authorize_url(params = {})
      _verify_client(params.delete(:endpoint))
      oauth_client.auth_code.authorize_url(params)
    end

    # Makes request to token endpoint and retrieves access token value
    def get_token(authorization_code, params = {})
      _verify_client(params.delete(:endpoint))
      oauth_client.auth_code.get_token(authorization_code, params)
    end

    # Grant type none
    def get_client_token(params = {})
      _verify_client(params.delete(:endpoint))
      data = {
        client_id: client_id,
        client_secret: client_secret,
        grant_type: 'none'
      }
      oauth_client.get_token(data)
    end

    # Check whether authentication credentials are present
    def authenticated?
      basic_authed? || oauth_token?
    end

    # Check whether basic authentication credentials are present
    def basic_authed?
      (login? && password?)
    end

    # Select authentication parameters
    def authentication
      if login? && password?
        { :login => login, :password => password }
      else
        { }
      end
    end

    private

    # Verifies the client_id and secret are provided, also resets the
    # oauth authorizations endpoint if it has been changed.
    def _verify_client(endpoint = "https://www.dtime.com") # :nodoc:
      raise ArgumentError, 'Need to provide client_id and client_secret' unless client_id? && client_secret?
      unless @client_endpoint == endpoint
        @oauth_client = nil
        @client_endpoint = endpoint
      end
    end

  end # Authorization
end # Dtime
