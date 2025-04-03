# frozen_string_literal: true

require 'formatic/templates/date'

module Formatic
  # Date/calendar
  class Time < ::Formatic::Base
    option :minute_step, default: -> { 5 }

    erb_template <<~ERB
      <%= render wrapper do |wrap| -%>

        <% wrap.with_input do -%>
          <div class="c-formatic-time s-formatic">

          <% if readonly %>
            <div class="s-markdown">
              <p>
                <%= value.to_fs(:time) %>
              </p>
            </div>
          <% else %>

            <div class="c-formatic-time__inputs">
              <%= select_tag hour_attribute_name,
                             options_for_hour,
                             id: hour_input_id,
                             class: 'c-formatic-time__select' %>

              <%= select_tag minute_attribute_name,
                             options_for_minute,
                             id: minute_input_id,
                             class: 'c-formatic-time__select' %>
            </div>

          <% end -%>
        <% end -%>
      <% end -%>
    ERB

    # Usually the time component is used below the date component (for a DateTime attribute).
    # So, normally we don't want the label to be shown twice.
    def label
      false
    end

    def options_for_hour
      options_for_select collection_for_hour, f.object.public_send(attribute_name)&.hour
    end

    def options_for_minute
      options_for_select collection_for_minute, f.object.public_send(attribute_name)&.min
    end

    def hour_attribute_name
      "#{f.object.model_name.param_key}[#{attribute_name}(4i)]"
    end

    def minute_attribute_name
      "#{f.object.model_name.param_key}[#{attribute_name}(5i)]"
    end

    def hour_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_4i"
    end

    def minute_input_id
      "#{f.object.model_name.param_key}_#{attribute_name}_5i"
    end

    private

    def collection_for_hour
      result = (0..23).map { [_1, _1] }
      result.prepend([nil, nil]) if wrapper.optional?
      result
    end

    def collection_for_minute
      sanitized_minute_step = minute_step.clamp(1, 60)
      steps = (0..59).step(sanitized_minute_step).to_a
      result = steps.map { [_1, _1] }
      result.prepend([nil, nil]) if wrapper.optional?
      result
    end
  end
end
