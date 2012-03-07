module Dtime
  class Error < StandardError
    attr_reader :response_message, :response_headers

    def initialize(message, headers = {})
      @response_message = message
      super message
    end

    def inspect
      %(#<#{self.class}>)
    end
  end # Error


  # API warnings
  # Raised when an unknown rel is requested
  class UnknownRel < Error; end

  # Raised when a template does not exist
  # but you ask for one
  class NoTemplate < Error; end

  # Raised when someone tries to post without paying
  # attention to template
  class TemplateMismatch < Error; end


  # Status code related
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
