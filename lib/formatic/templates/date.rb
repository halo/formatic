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

              <div class="c-formatic-date__inputs">
                <% if discard_day %>
                  <%= hidden_field_tag day_attribute_name, (day_value || 1) %>
                <% else %>
                  <%= select_tag day_attribute_name,
                                 options_for_day,
                                 id: day_input_id,
                                 class: 'c-formatic-date__select js-formatic-date__day' %>
                <% end %>

                <%= select_tag month_attribute_name,
                                options_for_month,
                                id: month_input_id,
                                class: 'c-formatic-date__select js-formatic-date__month' %>

                <%= select_tag year_attribute_name,
                                options_for_year,
                                id: year_input_id,
                                class: 'c-formatic-date__select js-formatic-date__year' %>
              </div>
              <% unless discard_day %>
                <div class="c-formatic-date__calendar">
                  <a class="c-formatic-date__flick c-formatic-date__clear js-formatic-date__shortcut" href="#"
                     data-day=""
                     data-month=""
                     data-year=""
                  >
                    X
                  </a>
                  <% calendar.each do |day| %>
                    <a class="c-formatic-date__flick <%= day.classes %> js-formatic-date__shortcut"
                      href='#'
                      data-day="<%= day.date.day %>"
                      data-month="<%= day.date.month %>"
                      data-year="<%= day.date.year %>"
                    >
                    <span class="c-formatic-date__calendar-day-number"><%= I18n.l(day.date, format: "%e").strip %></span>
                      <span class="c-formatic-date__calendar-month"><%= I18n.l(day.date, format: "%b") %></span>
                      <span class="c-formatic-date__calendar-year"><%= I18n.l(day.date, format: "%y") %></span>
                    </a>
                  <% end %>
                </div>
              <% end %>
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
