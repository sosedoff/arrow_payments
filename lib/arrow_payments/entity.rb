require 'hashie'

module ArrowPayments
  class Entity < Hashie::Trash
    include Hashie::Extensions::Coercion

    class << self
      attr_reader :properties_map
    end

    instance_variable_set('@properties_map', {})

    def to_source_hash(options={})
      hash = {}

      self.class.properties_map.each_pair do |k, v|
        val = send(k)
        hash[v] = val unless val.nil?
      end

      hash
    end

    def self.property(property_name, options = {})
      super(property_name, options)

      if options[:from]
        @properties_map ||= {}
        @properties_map[property_name.to_sym] = options[:from].to_s
      end
    end

    private

    def property_exists?(property)
      self.class.property?(property.to_sym)
    end
  end
end