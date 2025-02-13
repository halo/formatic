# frozen_string_literal: true

module Formatic
  class Choices
    # Returns raw options suitable for a <select> box.
    class Options
      include Calls

      option :f
      option :options
      option :attribute_name
      option :include_current

      def call
        candidates = options
        return candidates unless currently_associated_record && include_current
        return candidates if records&.include?(currently_associated_record)

        candidates.prepend currently_associated_record.presenters.for_select
        candidates
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
