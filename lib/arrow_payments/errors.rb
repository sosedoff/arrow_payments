module ArrowPayments
  # Generic API error
  class Error < StandardError ; end

  # Error when API entity is not found
  class NotFound < Error ; end
end