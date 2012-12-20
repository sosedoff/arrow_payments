module ArrowPayments
  module Customers
    # Get all existing customers
    # @return [Array<Customer>]
    def customers
      get('/customers').map { |c| Customer.new(c) }
    end

    # Get an existing customer
    # @param [Integer] customer ID
    # @return [Customer]
    def customer(id)
      Customer.new(get("/customer/#{id}"))
    rescue NotFound
      nil
    end

    # Create a new customer
    # @param [Hash] customer attributes
    # @return [Customer]
    def create_customer(options={})
      customer = options.kind_of?(Hash) ? Customer.new(options) : options
      Customer.new(post("/customer/add", customer.to_source_hash))
    end

    # Update an existing customer attributes
    # @param [Integer] customer ID
    # @param [Hash] customer attributes
    # @return [Customer]
    def update_customer(id, options={})
      raise ArrowPayments::NotImplemented
    end

    # Delete an existing customer
    # @param [Integer] customer ID
    # @return [Boolean]
    def delete_customer(id)
      raise ArrowPayments::NotImplemented
    end
  end
end