# frozen_string_literal: true

module Formatic
  # Text input for one-liners.
  class String < ::Formatic::Base
    option :terminal, default: -> { false }

    def input_options
      result = {
        placeholder: wrapper.placeholder,
        autofocus: !autofocus.nil?,
        class: (css_classes << 'c-input-string-component__input')
      }

      (result[:value] = value) if value

      result
    end

    def css_classes
      terminal? ? ['is-terminal'] : []
    end

    private

    attr_reader :autofocus

    def terminal?
      !!@terminal
    end
  end
end
