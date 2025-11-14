# frozen_string_literal: true

require 'formatic/templates/date'

module Formatic
  # Date/calendar
  class Date < ::Formatic::Base
    option :calendar, as: :show_calendar, default: -> { true }

    # Represents one element in the calendar.
    class Day
      extend Dry::Initializer

      option :date

      def classes
        [
          ('is-today' if date.today?),
          ('is-saturday' if date.saturday?),
          ('is-sunday' if date.sunday?),
          ('is-holiday' if holiday?)
        ].join(' ')
      end

      private

      def holiday?
        return false if date.saturday? || date.sunday?

        ::Holidays.on(date, :de_nw).present?
      end
    end

    # When this is set, we always submit `1` as the day.
    #
    # We could also assume the currently set day, but that could lead to switching months on submit:
    # If 2016-12-31 is set and the form changes to 2016-11, it becomes 2016-11-31 (i.e. 2016-12-01).
    option :discard_day, optional: true

    erb_template(::Formatic::Templates::Date.call)

    def css_classes
      %i[c-formatic-date__input]
    end

    def calendar?
      return false if show_calendar == false
      return false if discard_day

      true
    end

    def options_for_day
      options_for_select collection_for_day, f.object.public_send(attribute_name)&.day
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

    def day_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_3i"
    end

    def month_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_2i"
    end

    def year_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_1i"
    end

    def calendar(now: ::Time.current)
      from = 5.days.ago.to_date
      till = now.beginning_of_month.advance(months: 2).end_of_month.to_date

      (from..till).map do |date|
        ::Formatic::Date::Day.new(date:)
      end
    end

    private

    def collection_for_day
      return (1..31) if wrapper.required?

      [nil] + (1..31).to_a
    end

    def collection_for_month
      result = (1..12).map { [l(::Date.new(1, it), format: '%B  %-m'), it] }
      result.prepend([nil, nil]) if wrapper.optional?
      result
    end

    def collection_for_year
      result = (30.years.ago.year..10.years.from_now.year)
      return result if wrapper.required?

      result.to_a.prepend nil
    end
  end
end
