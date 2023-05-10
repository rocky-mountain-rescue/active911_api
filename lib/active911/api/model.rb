# frozen_string_literal: true

require "ostruct"

module Active911::API
  class Model < OpenStruct
    attr_reader :to_json

    def initialize(attributes)
      super(to_ostruct(attributes))
      @to_json = attributes
    end

    def to_ostruct(obj)
      case obj
      when Hash
        OpenStruct.new(obj.transform_values { |val| to_ostruct(val) })
      when Array
        obj.map { |array_element| to_ostruct(array_element) }
      else
        # Assumed to be a primitive value
        obj
      end
    end
  end
end
