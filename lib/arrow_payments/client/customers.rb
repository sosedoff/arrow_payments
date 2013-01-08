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
    # @param [Customer] customer instance
    # @return [Boolean] update result
    def update_customer(customer)
      params = customer.to_source_hash
      params['CustomerID'] = customer.id

      resp = post('/customer/update', params)
      resp['Success'] == true
    end

    # Delete an existing customer
    # @param [Integer] customer ID
    # @return [Boolean]
    def delete_customer(id)
      resp = post('/customer/delete', 'CustomerID' => id)
      resp['Success'] == true
    end
  end
end