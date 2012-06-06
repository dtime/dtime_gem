require 'faraday'
require 'dtime/error'

module Dtime
  module Connection
    module Response
      class RaiseError < Faraday::Response::Middleware

        def on_complete(env)
          case env[:status].to_i
          when 400
            raise Dtime::BadRequest.new(response_message(env), env)
          when 401
            raise Dtime::Unauthorized.new(response_message(env), env)
          when 403
            raise Dtime::Forbidden.new(response_message(env), env)
          when 404
            raise Dtime::ResourceNotFound.new(response_message(env), env)
          when 405
            raise Dtime::MethodNotAllowed.new(response_message(env), env)
          when 422
            raise Dtime::UnprocessableEntity.new(response_message(env), env)
          when 500
            raise Dtime::InternalServerError.new(response_message(env), env)
          when 503
            raise Dtime::ServiceUnavailable.new(response_message(env), env)
          when 400...600
            raise Dtime::Error.new(response_message(env), env)
          end
        end

        def response_message(env)
          msg = env[:body].respond_to?(:message) ? env[:body].message : env[:body]
          if Dtime.verbose_errors
            "#{env[:method].to_s.upcase} #{env[:url].to_s}: #{env[:status]} #{msg}"
          else
            msg
          end
        end

      end # Response::RaiseError
    end
  end
end # Dtime
