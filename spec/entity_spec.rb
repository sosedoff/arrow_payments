require 'spec_helper'

class EntityTester < ArrowPayments::Entity
  property :foo,     :from => 'Foo'
  property :foobar,  :from => 'Foobar'
  property :foo_bar, :from => 'FooBar'
end

describe ArrowPayments::Entity do
  let(:attributes) do
    {'Foo' => 'a', 'Foobar' => 'b', 'FooBar' => 'c'}
  end

  describe '#new' do
    it 'assigns properties' do
      entity = EntityTester.new(attributes)

      entity.foo.should eq('a')
      entity.foobar.should eq('b')
      entity.foo_bar.should eq('c')
    end

    it 'ignores undefined attributes' do
      entity = EntityTester.new(attributes.merge('Bro' => 'Sup?'))

      expect { entity.foo }.not_to raise_error
      expect { entity['Bro'] }.to raise_error NoMethodError
    end
  end

  describe '#properties_map' do
    it 'returns hash with property mappings' do
      map = EntityTester.properties_map

      map.should be_a Hash
      map.should_not be_empty
      map.keys.should include(:foo, :foobar, :foo_bar)
      map[:foo].should eq('Foo')
      map[:foobar].should eq('Foobar')
      map[:foo_bar].should eq('FooBar')
    end
  end

  describe '#to_source_hash' do
    it 'returns hash as source format' do
      entity = EntityTester.new(attributes)
      hash = entity.to_source_hash

      hash.size.should eq(3)
      hash['Foo'].should eq('a')
      hash['Foobar'].should eq('b')
      hash['FooBar'].should eq('c')
    end
  end
end
