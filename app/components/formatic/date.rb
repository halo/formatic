# frozen_string_literal: true

require 'formatic/templates/date'

module Formatic
  # Date/calendar
  class Date < ::Formatic::Base
    option :discard_day, default: -> {}

    erb_template(::Formatic::Templates::Date.call)

    def css_classes
      %i[c-formatic-date__input]
    end

    def options_for_day
      options_for_select collection_for_day, day_value
    end

    def options_for_month
      options_for_select collection_for_month, f.object.public_send(attribute_name)&.month
    end

    def options_for_year
      options_for_select collection_for_year, f.object.public_send(attribute_name)&.year
    end

    def day_attribute_name
      "#{f.object.model_name.param_key}[#{attribute_name}(3i)]"
    end

    def month_attribute_name
      "#{f.object.model_name.param_key}[#{attribute_name}(2i)]"
    end

    def year_attribute_name
      "#{f.object.model_name.param_key}[#{attribute_name}(1i)]"
    end

    def day_value
      f.object.public_send(attribute_name)&.day
    end

    def day_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_3i"
    end

    def month_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_2i"
    end

    def year_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_1i"
    end

    private

    def collection_for_day
      return (1..31) if wrapper.required?

      [nil] + (1..31).to_a
    end

    def collection_for_month
      result = (1..12).map { [l(::Date.new(1, _1), format: '%B  %-m'), _1] }
      result.prepend([nil, nil]) unless wrapper.required?
      result
    end

    def collection_for_year
      result = (30.years.ago.year..10.years.from_now.year)
      return result if wrapper.required?

      result.to_a.prepend nil
    end
  end
end
