module ArrowPayments
  class LineItem < Entity
    property :id,              :from => 'ID'
    property :commodity_code,  :from => 'CommodityCode'
    property :description,     :from => 'Description'
    property :price,           :from => 'Price'
    property :product_code,    :from => 'ProductCode'
    property :unit_of_measure, :from => 'UnitOfMeasure'
  end
end
