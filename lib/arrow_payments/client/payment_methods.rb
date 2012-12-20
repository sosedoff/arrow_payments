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

  # Setup a new payment method
  # @param [String] token ID from payment method setup 
  # @param [PaymentMethod] payment method instance or hash
  def payment_method_setup(token_id, payment_method)
    cc = payment_method

    if payment_method.kind_of?(Hash)
      cc = ArrowPayments::PaymentMethod.new(payment_method)
    end

    # TODO: No imformation how to proceed
    raise ArrowPayments::NotImplemented
  end

  # Complete payment method creation
  # @param [String] token ID
  # @return [PaymentMethod]
  def payment_method_complete(token_id)
    resp = post('/paymentmethod/complete', 'TokenID' => token_id)
    ArrowPayments::PaymentMethod.new(resp)
  end

  private

  def payment_method_form(cc)
    {
      'billing-cc-number'  => cc.number,
      'billing-cc-exp'     => [cc.expiration_month, cc.expiration_year].join,
      'billing-cvv'        => cc.security_code,
      'billing-first-name' => cc.first_name,
      'billing-last-name'  => cc.last_name
    }
  end
end