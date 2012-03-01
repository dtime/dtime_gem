module Dtime
  class Error < StandardError
    attr_reader :response_message, :response_headers

    def initialize(message, headers)
      @response_message = message
      super message
    end

    def inspect
      %(#<#{self.class}>)
    end
  end # Error

  # Raised when Dtime returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when Dtime returns the HTTP status code 401
  class Unauthorized < Error; end
  #
  # Raised when Dtime returns the HTTP status code 422
  class UnprocessableEntity < Error; end

  # Raised when Dtime returns the HTTP status code 403
  class Forbidden < Error; end

  # Raised when Dtime returns the HTTP status code 404
  class ResourceNotFound < Error; end

  # Raised when Dtime returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when Dtime returns the HTTP status code 503
  class ServiceUnavailable < Error; end

end # Dtime
