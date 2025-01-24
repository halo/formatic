# frozen_string_literal: true

module Formatic
  # Dropdown box
  class Select < ::Formatic::Base
    # Alternative 1:
    # Raw options that are passed on to the Rails select_box_tag.
    option :options, optional: true

    # Alternative 2:
    # ActiveRecord records used to populate the select box.
    option :records, optional: true

    # Alternative 3:
    # Key to lookup in i18n translations.
    option :slugs, optional: true

    # Whether or not to show an empty (nil) option.
    option :include_blank, default: -> { :guess }

    erb_template(::Formatic::Templates::Select.call)

    def choices
      ::Formatic::Selects::Choices.call(
        f:,
        attribute_name:,
        records:,
        slugs:,
        include_blank: include_blank?
      )
    end

    def current_choice_name
      choices.detect { _1.last == record&.id }&.first
    end

    def include_blank?
      return wrapper.optional? if @include_blank == :guess

      !!@include_blank
    end
  end
end
