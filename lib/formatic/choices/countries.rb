# frozen_string_literal: true

module Formatic
  class Choices
    # Returns a list of countries suitable for a <select> box.
    class Countries
      include Calls

      def call
        ::ISO3166::Country.pluck(:iso_short_name, :alpha2)
      end
    end
  end
end
