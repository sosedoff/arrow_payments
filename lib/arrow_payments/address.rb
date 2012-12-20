module ArrowPayments
  class Address < Entity
    property :address,  :from => 'Address1'
    property :address2, :from => 'Address2'
    property :city,     :from => 'City'
    property :state,    :from => 'State'
    property :zip,      :from => 'Postal'
    property :phone,    :from => 'Phone'
    property :tag,      :from => 'Tag'
  end
end