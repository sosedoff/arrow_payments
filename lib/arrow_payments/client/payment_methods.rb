module ArrowPayments
  module PaymentMethods
    # Get a single payment method
    # @param [Integer] customer ID
    # @param [Integer] payment method ID
    # @return [PaymentMethod] payment method instance
    def payment_method(customer_id, id)
      customer(customer_id).payment_methods.select { |cc| cc.id == id }.first
    end

    # Start a new payment method
    # @param [Integer] customer ID
    # @param [Address] billing address instance
    # @param [String] return url
    # @return [String] payment method form url
    def start_payment_method(customer_id, billing_address, return_url=nil)
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

      post("/paymentmethod/start", params)['FormPostUrl']
    end

    # Setup a new payment method
    # @param [String] payment method form url
    # @param [PaymentMethod] payment method instance or hash
    # @return [String] confirmation token
    def setup_payment_method(form_url, payment_method)
      cc = payment_method

      if payment_method.kind_of?(Hash)
        cc = ArrowPayments::PaymentMethod.new(payment_method)
      end

      resp = post_to_url(form_url, payment_method_form(cc))
      resp.headers['location'].scan(/token-id=(.*)/).flatten.first
    end

    # Complete payment method creation
    # @param [String] token ID
    # @return [PaymentMethod]
    def complete_payment_method(token_id)
      resp = post('/paymentmethod/complete', 'TokenID' => token_id)
      ArrowPayments::PaymentMethod.new(resp)
    end

    # Create a new payment method. This is a wrapper on top of 3 step process
    # @param [Integer] customer ID
    # @param [Address] credit card address
    # @param [PaymentMethod] credit card
    # @return [PaymentMethod]
    def create_payment_method(customer_id, address, card)
      url   = start_payment_method(customer_id, address)
      token = setup_payment_method(url, card)
      
      complete_payment_method(token)
    end

    # Delete an existing payment method
    # @param [Integer] payment method ID
    # @return [Boolean]
    def delete_payment_method(id)
      resp = post('/paymentmethod/delete', 'PaymentMethodId' => id)
      resp['Success'] == true
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
end