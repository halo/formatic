# frozen_string_literal: true

module Formatic
  # File upload
  class File < ::Formatic::Base
    option :direct_upload, default: -> { true }
    option :multiple, default: -> { false }
    option :accept, default: -> {}

    erb_template <<~ERB
      <%= render wrapper do |wrap| %>

        <% wrap.with_input do %>

          <div class="c-formatic-file js-formatic-file"'>

            <%-
              # Make sure we don't loose uploaded files on submit if JS is failing
              # (If JS fails, the empty file <input> would cause AS to purge)
            -%>
            <div class="js-formatic-file__hidden-fields">
              <%- attachments&.each do |attachment| -%>
                <%- if attachment.present? -%>
                  <%= hidden_field_tag input_name, attachment.signed_id %>
                <%- end -%>
              <%- end -%>
            </div>

            <%= f.file_field attribute_name, class: "js-formatic-file__input", direct_upload:, multiple:, accept:, data: %>

            <%- if (file = current_file) -%>
              <div class="c-formatic-file__current">
                <%= link_to 'Download', file, target: :_blank %>
              </div>
            <%- end -%>
          </div>
        <% end %>
      <% end %>
    ERB

    def data
      { entries: entries_json }.merge(manual_data)
    end

    def before_render
      validate_attribute_name!
    end

    private

    def validate_attribute_name!
      # A manually passed value means `attribute_name` is just a param name,
      # not necessarily a method on the model.
      return if manual_value != :_fetch_from_record
      return if f.nil? || f.object.nil?

      # Only enforce this for real ActiveModel/ActiveRecord records.
      # Custom objects (e.g. slugs) are not expected to respond to it.
      return unless f.object.respond_to?(:model_name)
      return if f.object.respond_to?(attribute_name)

      raise ArgumentError,
            "attribute `#{attribute_name}` does not exist on #{f.object.class}."
    end

    def attachments
      return [] if value.blank?

      # ActiveStorage::Attached::Many
      return value.attachments if value.respond_to?(:attachments)

      # ActiveStorage::Attached::One
      [value.attachment]
    end

    def entries_json
      # Filepond doesn't work well  with invalid form submits anyway.
      return if multiple

      attachments.map do |attachment|
        {
          source: attachment.signed_id,
          options: {
            type: 'local',
            file: {
              name: attachment.filename,
              size: attachment.byte_size,
              type: attachment.content_type
            }
          }
        }
      end.to_json
    end

    # The currently attached file, if there is exactly one.
    # Multiple files are not shown here, see `Formatic::Files`.
    def current_file
      return if multiple
      return unless attachments.size == 1

      attachment = attachments.first
      attachment if attachment.present?
    end
  end
end
