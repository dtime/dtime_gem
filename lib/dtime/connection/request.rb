require 'dtime/connection/request/oauth2'
require 'dtime/connection/request/basic_auth'

require 'base64'
require 'addressable/uri'
require 'multi_json'

module Dtime
  module Connection
    # Defines HTTP verbs, creating convenience methods for
    # using the connection.
    module Request

      METHODS = [:get, :post, :put, :delete, :patch, :options, :head]
      METHODS_WITH_BODIES = [ :post, :put, :patch ]

      def _get(path, params={}, opts={})
        _request(:get, path, params, opts)
      end

      def _patch(path, params={}, opts={})
        _request(:patch, path, params, opts)
      end

      def _head(path, params={}, opts={})
        _request(:head, path, params, opts)
      end

      def _options(path, params={}, opts={})
        _request(:options, path, params, opts)
      end

      def _post(path, params={}, opts={})
        _request(:post, path, params, opts)
      end
      def _post_file(path, params={}, opts={})
        _file_request(:post, path, params, opts)
      end

      def _put(path, params={}, opts={})
        _request(:put, path, params, opts)
      end

      def _delete(path, params={}, opts={})
        _request(:delete, path, params, opts)
      end
      def _file_request(method, path, params, opts)
        path = get_path_for(path)
        if !METHODS.include?(method)
          raise ArgumentError, "unkown http method: #{method}"
        end
        puts "EXECUTED: #{method} - #{path} with #{params} and #{opts}"

        response = file_connection(opts).run_request(method, path, params, nil) do |request|
          case method.to_sym
          when *(METHODS - METHODS_WITH_BODIES)
            request.url(path, params)
          when *METHODS_WITH_BODIES
            request.body = params unless params.empty?
          end
        end
        self.last_response = response.body
        response.body
      end

      def _request(method, path, params, opts)
        path = get_path_for(path)
        if !METHODS.include?(method)
          raise ArgumentError, "unkown http method: #{method}"
        end
        # puts "EXECUTED: #{method} - #{path} with #{params} and #{opts}"

        response = connection(opts).run_request(method, path, params, nil) do |request|
          case method.to_sym
          when *(METHODS - METHODS_WITH_BODIES)
            request.url(path, params)
          when *METHODS_WITH_BODIES
            request.body = MultiJson.encode(params) unless params.empty?
          end
        end
        self.last_response = response.body
        response.body
      end

      # Get a link for a given rel.
      # Pass force to get a link from the homepage when nothing has been fetched
      def link_for_rel(rel, opts = {})
        force = opts.delete(:force)
        if last_response?
          last_response.link_for(rel, opts)
        elsif force
          self._get('/')
          last_response.link_for(rel, opts)
        else
          nil
        end
      end

      def links
        if last_response && last_response._links?
          last_response._links
        else
          nil
        end
      end

      # Fetches a link for a given rel
      # if the rel doesn't start with a slash and
      # there was a previous request to fetch a link from
      def get_path_for(path)
        if path.respond_to?(:href)
          path = path.href
        elsif path =~ /^[^\/]/
          if link = link_for_rel(path)
            path = link.href
          end
        end
        path
      end

    end # Request
  end
end # Dtime
