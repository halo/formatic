# frozen_string_literal: true

module Formatic
  module Templates
    # Holds the ERB template for this component.
    module Date
      TEMPLATE = <<~ERB
        <%= render wrapper do |wrap| %>

          <% wrap.with_input do %>
            <div class="c-formatic-date s-formatic js-formatic-date">

            <% if readonly %>
              <div class="s-markdown">
                <p>
                  <%= value.to_date %>
                </p>
              </div>
            <% else %>

              <div class="c-formatic-date__date">
                <% if discard_day %>
                  = hidden_field_tag day_attribute_name, (day_value || 1)
                <% else %>
                  <%= select_tag day_attribute_name,
                                 options_for_day,
                                 id: day_input_id,
                                 class: 'c-formatic-date__part js-formatic-date__day' %>

                  <%= select_tag month_attribute_name,
                                 options_for_month,
                                 id: month_input_id,
                                 class: 'c-formatic-date__part js-formatic-date__month' %>

                  <%= select_tag year_attribute_name,
                                 options_for_year,
                                 id: year_input_id,
                                 class: 'c-formatic-date__part js-formatic-date__year' %>
                <% end %>
              </div>

              <div class="c-formatic-date__shortcuts">
                <a class="c-formatic-date__shortcut js-formatic-date__shortcut"
                   href='#'
                   data-year=''>
                   <%= t('formatic.date.blank') %>
                </a>

                <a class="c-formatic-date__shortcut js-formatic-date__shortcut"
                   href='#'
                   data-day="<%= 1.day.ago.day %>"
                   data-month="<%= 1.day.ago.month %>"
                   data-year="<%= 1.day.ago.year %>">
                   Gestern
                </a>

                <a class="c-formatic-date__shortcut js-formatic-date__shortcut"
                   href='#'
                   data-day="<%= Date.current.day %>"
                   data-month="<%= Date.current.month %>"
                   data-year="<%= Date.current.year %>">
                   Heute
                </a>

                <a class="c-formatic-date__shortcut js-formatic-date__shortcut"
                   href='#'
                   data-day="<%= 1.day.from_now.day %>"
                   data-month="<%= 1.day.from_now.month %>"
                   data-year="<%= 1.day.from_now.year %>">
                   Morgen
                </a>

                <a class="c-formatic-date__shortcut js-formatic-date__shortcut"
                   href='#'
                   data-day="<%= Time.current.next_week.to_date.day %>"
                   data-month="<%= Time.current.next_week.to_date.month %>"
                   data-year="<%= Time.current.next_week.to_date.year %>">
                   Nächste Woche
                </a>

                <a class="c-formatic-date__shortcut js-formatic-date__shortcut"
                   href='#'
                   data-day="<%= Time.current.next_month.to_date.day %>"
                   data-month="<%= Time.current.next_month.to_date.month %>"
                   data-year="<%= Time.current.next_month.to_date.year %>">
                   Nächsten Monat
                </a>
              </div>
            <% end %>

            </div>
          <% end %>
        <% end %>
      ERB

      private_constant :TEMPLATE

      def self.call
        TEMPLATE
      end
    end
  end
end
