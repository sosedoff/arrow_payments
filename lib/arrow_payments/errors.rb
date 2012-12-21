module ArrowPayments
  # Generic API error
  class Error < StandardError ; end

  # Error when API entity is not found
  class NotFound < Error ; end

  # Error when API endpoint or method is not implemented
  class NotImplemented < Error ; end

  # Bad request error, does not contain a message
  class BadRequest < Error ; end
end