# frozen_string_literal: true

require "ostruct"

module Active911
  module API
    class Model < OpenStruct
      attr_reader :to_json
      def initialize attributes
        super to_ostruct(attributes)
        @to_json = attributes
      end

      def to_ostruct obj
        case obj
          when Hash
            OpenStruct.new(obj.transform_values { |val| to_ostruct(val) })
          when Array
            obj.map { |o| to_ostruct(o) }
          else
            # Assumed to be a primitive value
            obj
        end
      end
    end
  end
end
