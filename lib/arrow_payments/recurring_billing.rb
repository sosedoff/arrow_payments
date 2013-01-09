# From documentation:
# * Frequency -> W, M, Q, Y (weekly, monthly, quarterly, yearly)
# * TransactionDay -> Weekly: [1-7], Monthly: [1-28], Quarterly:[1,2,3], Yearly: [1-12]

module ArrowPayments
  class RecurringBilling < Entity
    FREQUENCIES = %w(W M Q Y)
    FREQUENCY_NAMES = {
      'W' => 'Weekly',
      'M' => 'Monthly', 
      'Q' => 'Quarterly',
      'Y' => 'Yearly'
    }

    property :id,                :from => 'ID'
    property :payment_method_id, :from => 'PaymentMethodId'
    property :frequency,         :from => 'Frequency'
    property :total_amount,      :from => 'TotalAmount'
    property :shipping_amount,   :from => 'ShippingAmount'
    property :description,       :from => 'Description'
    property :transaction_day,   :from => 'TransactionDay'
    property :date_created,      :from => 'DateCreated'

    # Get billing frequency name
    # @return [String]
    def frequency_name
      FREQUENCY_NAMES[frequency]
    end
  end
end