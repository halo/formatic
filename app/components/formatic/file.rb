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

            <%= f.file_field attribute_name, class: "js-formatic-file__input", direct_upload:, multiple:, accept:, data: { entries: entries_json } %>
          </div>
        <% end %>
      <% end %>
    ERB

    private

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
  end
end
