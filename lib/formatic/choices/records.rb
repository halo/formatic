# frozen_string_literal: true

module Formatic
  class Choices
    # Returns a list of countries suitable for a <select> box.
    class Records
      include Calls

      option :f
      option :records
      option :attribute_name
      option :include_current

      def call
        candidates = records_to_options || []
        return candidates unless currently_associated_record && include_current?
        return candidates if records&.include?(currently_associated_record)

        candidates.prepend currently_associated_record.presenters.for_select
        candidates
      end

      def include_current?
        include_current != false
      end

      def records_to_options
        records&.map(&:presenters)&.map(&:for_select)
      end

      def currently_associated_record
        return unless association
        return unless f.object

        f.object.public_send(association.name)
      end

      def association
        model_klass = f&.object&.class
        return false unless model_klass.respond_to?(:reflect_on_all_associations)

        model_klass.reflect_on_all_associations(:belongs_to)
                   .detect { _1.foreign_key == attribute_name.to_s }
      end
    end
  end
end
