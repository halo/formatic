# frozen_string_literal: true

module Formatic
  module Wrappers
    # Checks if an attribute name is from an associated model.
    class AlternativeAttributeName
      include Calls

      param :attribute_name

      def call
        return unless attribute_name.to_s.end_with?('_id')

        attribute_name[...-3].to_sym
      end
    end
  end
end
