# frozen_string_literal: true

module Formatic
  module Selects
    # Calculates options for the select box.
    class Choices
      include Calls

      option :f
      option :attribute_name
      option :include_blank, optional: true

      option :options, optional: true
      option :records, optional: true
      option :slugs, optional: true

      def call
        result = choices
        result.prepend [nil, nil] if include_blank
        result
      end

      private

      def choices
        return options if options.present?
        return countries_to_choices if country_code?
        return slugs_to_choices if slugs.present?

        records_for_choices
      end

      # ------------
      # Associations
      # ------------

      def records_for_choices
        candidates = records_to_options || []
        return candidates unless currently_associated_record
        return candidates if records&.include?(currently_associated_record)

        # The currently selected association should be in the list of choosable records.
        # Otherwise a pristine form update would modify this value.
        # Arguably, this only works when you pass in records to choose from. Not raw options.
        candidates.prepend currently_associated_record.presenters.for_select
        candidates
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

      # ---------
      # Countries
      # ---------

      def country_code?
        attribute_name.to_s.end_with?('country_code')
      end

      def countries_to_choices
        ISO3166::Country.pluck(:iso_short_name, :alpha2)
      end

      # ----
      # I18n
      # ----

      def slugs_to_choices
        slugs.map do |slug|
          caption = ::Formatic::Wrappers::Translate.call(
            prefix: :'helpers.options',
            object: f.object,
            attribute_name: "#{attribute_name}.#{slug}",
            object_name: f&.object_name
          )

          [caption, slug.to_s]
        end
      end
    end
  end
end
