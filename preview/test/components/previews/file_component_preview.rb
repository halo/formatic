# frozen_string_literal: true

class FileComponentPreview < ViewComponent::Preview
  def single; end
  def multiple; end

  # Shows the existing single file underneath the input.
  def single_with_existing_file
    user = User.find_or_create_by!(id: 1)
    unless user.avatar.attached?
      user.avatar.attach(io: StringIO.new('I am a demo file.'), filename: 'demo.txt',
                         content_type: 'text/plain')
    end
    { assigns: { user: } }
  end
end
