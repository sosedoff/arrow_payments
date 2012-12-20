module ArrowPayments
  class RecurringBilling < Entity
    property :id,                :from => 'ID'
    property :payment_method_id, :from => 'PaymentMethodId'
    property :frequency,         :from => 'Frequency'
    property :total_amount,      :from => 'TotalAmount'
    property :shipping_amount,   :from => 'ShippingAmount'
    property :description,       :from => 'Description'
    property :transaction_day,   :from => 'TransactionDay'
    property :date_created,      :from => 'DateCreated'
  end
end