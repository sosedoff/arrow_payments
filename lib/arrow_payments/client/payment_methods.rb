module ArrowPayments
  module PaymentMethods
    # Start a new payment method
    # @param [Integer] customer ID
    # @param [Address] billing address instance
    # #param [String] return url
    def payment_method_start(customer_id, billing_address, return_url=nil)
      if billing_address.kind_of?(Hash)
        billing_address = ArrowPayments::Address.new(billing_address)
      end

      params = {
        'CustomerId'     => customer_id,
        'BillingAddress' => billing_address.to_source_hash
      }

      # If return url is blank means that its not browser-less payment method
      # creation. Reponse should include token ID for the Step 3.
      if return_url
        params['ReturnUrl'] = return_url
      end

      post("/paymentmethod/start", params)
    end
  end
end