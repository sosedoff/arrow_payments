module ArrowPayments
  class Customer < Entity
    property :id,                 :from => 'ID'
    property :name,               :from => 'Name'
    property :code,               :from => 'Code'
    property :contact,            :from => 'PrimaryContact'
    property :phone,              :from => 'PrimaryContactPhone'
    property :email,              :from => 'PrimaryContactEmailAddress'
    property :recurring_billings, :from => 'RecurrentBilling'
    property :payment_methods,    :from => 'PaymentMethods'

    def PaymentMethods=(data)
      if data.kind_of?(Array)
        self.payment_methods = data.map { |d| PaymentMethod.new(d) }
      else
        self.payment_methods = []
      end
    end

    def PaymentMethods
      (payment_methods || []).map(&:to_source_hash)
    end

    def RecurrentBillings=(data)
      if data.kind_of?(Array)
        self.recurring_billings = data.map { |d| RecurringBilling.new(d) }
      else
        self.recurring_billings = []
      end
    end

    def to_source_hash(options={})
      hash = super(options)
      hash.merge!('PaymentMethods' => (payment_methods || []).map(&:to_source_hash))
      hash
    end
  end
end