# frozen_string_literal: true

module Formatic
  module Wrappers
    # Extracts the message of an erroneous attribute
    class ErrorMessages
      include Calls

      option :object
      option :attribute_name

      def call
        return unless object

        (errors_on_attribute + error_on_association).uniq
      end

      private

      attr_reader :object

      def errors_on_attribute
        return [] unless object.respond_to?(attribute_name)

        object.errors.full_messages_for(attribute_name)
      end

      def error_on_association
        association_attribute_name = ::Formatic::Wrappers::AlternativeAttributeName.call(
          attribute_name
        )
        return [] unless association_attribute_name
        return [] unless object.respond_to?(association_attribute_name)

        object.errors.full_messages_for(association_attribute_name)
      end
    end
  end
end
