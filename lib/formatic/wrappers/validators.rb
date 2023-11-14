# frozen_string_literal: true

module Formatic
  module Wrappers
    # Examines the validators of a record.
    class Validators
      include Calls

      option :object
      option :attribute_name

      # This could later be made smarter (e.g. checking for conditionals)
      # See https://github.com/heartcombo/simple_form/blob/main/lib/simple_form/helpers/validators.rb#L15
      def call
        return [] unless object.class.respond_to?(:validators_on)

        attribute_validators + association_validators
      end

      private

      attr_reader :object

      def attribute_validators
        object.class.validators_on(attribute_name)
      end

      # `belongs_to :owner` validates `:owner_id`
      def association_validators
        association_attribute_name = ::Formatic::Wrappers::AlternativeAttributeName.call(
          attribute_name
        )
        return [] unless association_attribute_name

        object.class.validators_on(association_attribute_name)
      end
    end
  end
end
