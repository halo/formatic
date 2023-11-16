# frozen_string_literal: true

module Formatic
  module Wrappers
    # Looks up translations for placeholders, hints, etc.
    class Translate
      include Calls

      option :prefix
      option :object
      option :object_name, default: -> {}
      option :attribute_name

      def call
        if optimal_key
          I18n.t optimal_key, default: ([optimal_key] + fallback_keys), raise: true
        else
          I18n.t fallback_keys.first, default: fallback_keys[1..], raise: true
        end
      rescue I18n::MissingTranslationData
        nil
      end

      private

      def optimal_key
        return unless object

        :"#{prefix}.#{object.model_name.i18n_key}.#{attribute_name}"
      end

      def fallback_keys
        [
          (:"#{prefix}.#{object_name}.#{attribute_name}" if object_name),
          :"#{prefix}.default.#{attribute_name}",
          :"#{prefix}.#{attribute_name}"
        ]
      end
    end
  end
end
