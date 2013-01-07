require 'spec_helper'

describe ArrowPayments::LineItem do
  it { should respond_to :id }
  it { should respond_to :commodity_code }
  it { should respond_to :description }
  it { should respond_to :price }
  it { should respond_to :product_code }
  it { should respond_to :unit_of_measure }

  describe '#to_source_hash' do
    it 'returns a formatted hash' do
      item = ArrowPayments::LineItem.new(json_fixture('line_item.json'))
      item.to_source_hash.should eq(json_fixture('line_item.json'))
    end
  end
end