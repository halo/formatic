# frozen_string_literal: true

module Formatic
  # Calculates options for e.g. select boxes.
  class Choices
    include Calls

    option :f
    option :attribute_name
    option :include_blank, optional: true

    # The currently selected choice should be in the list of choosable choices.
    # Otherwise a simple form submit would modify this value.
    option :include_current, optional: true

    option :options, optional: true
    option :records, optional: true
    option :keys, optional: true

    def call
      result = choices
      result.prepend [nil, nil] if include_blank
      result
    end

    private

    def choices
      return options_choices if options.present?
      return country_choices if country_code?
      return keys_choices if keys.present?

      record_choices
    end

    def options_choices
      return options unless include_current

      # Could be implemented though.
      raise '`Formatic::Choices.call(options: ...)` cannot also have `include_current: true`'
    end

    def country_code?
      attribute_name.to_s.end_with?('country_code')
    end

    # Assuming that countries don't disappear, `include_current` is implied.
    def country_choices
      ::Formatic::Choices::Countries.call
    end

    def keys_choices
      return ::Formatic::Choices::Keys.call(f:, attribute_name:, keys:) unless include_current

      raise '`Formatic::Choices.call(keys: ...)` cannot also have `include_current: true`'
    end

    def record_choices
      ::Formatic::Choices::Records.call(f:, records:, attribute_name:, include_current:)
    end
  end
end
