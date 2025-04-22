# frozen_string_literal: true

module Formatic
  module Wrappers
    # Determines whether an attributes is optional or not.
    class Required
      include Calls

      option :manual_required
      option :object
      option :attribute_name

      # Could also be made smarter, e.g. global configuration.
      # See https://github.com/heartcombo/simple_form/blob/main/lib/simple_form/helpers/required.rb
      def call
        return true if manual_required == true
        return false if manual_required == false
        return false if validators.empty?

        validators.any? { applicable?(_1) }
      end

      private

      # All applicable validatiors of this attribute.
      def validators
        @validators ||= ::Formatic::Wrappers::Validators.call(object:, attribute_name:)
      end

      def applicable?(validator)
        validator.options.keys.exclude?(:if) &&
          validator.options.keys.exclude?(:unless) &&
          validator.options.keys.exclude?(:on) &&
          validator.kind == :presence
      end
    end
  end
end
