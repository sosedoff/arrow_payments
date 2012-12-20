require 'time'

module ArrowPayments
  class Transaction < Entity
    # Indicates status of transaction
    STATUSES = [
      'NotSettled',
      'Settled',
      'Voided',
      'Failed'
    ]

    # Indicates how the transation was entered
    SOURCES = [
      'VirtualTerminal',
      'LinkedTerminal',
      'API',
      'Subscription',
      'InvoicePayment',
      'Mobile'
    ]

    property :id,                    :from => 'ID'
    property :account,               :from => 'Account'
    property :transaction_type,      :from => 'TransactionType'
    property :created_at,            :from => 'TransactionTime'
    property :level,                 :from => 'Level'
    property :total_amount,          :from => 'TotalAmount'
    property :description,           :from => 'Description'
    property :transaction_source,    :from => 'TransactionSource'
    property :status,                :from => 'Status'
    property :capture_amount,        :from => 'CaptureAmount'
    property :authorization_code,    :from => 'AuthorizationCode'
    property :payment_method_id,     :from => 'PaymentMethodID'
    property :cardholder_first_name, :from => 'CardholderFirstName'
    property :cardholder_last_name,  :from => 'CardholderLastName'
    property :card_type,             :from => 'CardType'
    property :card_last_digits,      :from => 'CardLast4'
    property :customer_po_number,    :from => 'CustomerPONumber'
    property :tax_amount,            :from => 'TaxAmount'
    property :shipping_amount,       :from => 'ShippingAmount'
    property :shipping_address_id,   :from => 'ShippingAddressID'
    property :shipping_address,      :from => 'Shipping'
    property :customer_id,           :from => 'CustomerID'
    property :customer_name,         :from => 'CustomerName'
    property :line_items,            :from => 'LineItems'
    property :billing_address,       :from => 'Billing'

    def Billing=(data)
      if data.kind_of?(Hash)
        self.billing_address = ArrowPayments::Address.new(data)
      end
    end

    def Shipping=(data)
      if data.kind_of?(Hash)
        self.shipping_address = ArrowPayments::Address.new(data)
      end
    end

    def TransactionTime=(data)
      if data =~ /^\/Date\(([\d]+)\)\/$/
        epoch = Integer($1[0..9])
        self.created_at = Time.at(epoch).to_datetime
      end
    end
  end
end