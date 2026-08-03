# frozen_string_literal: true

require 'test_helper'

class FileModel
  include ActiveModel::API

  attr_accessor :the_file
end

# Mimics an ActiveStorage::Attachment with a `Home` model name
# so that `link_to` can resolve a route in the test application.
class FakeAttachment
  include ActiveModel::API

  attr_accessor :filename, :byte_size, :content_type

  def signed_id
    'signed-id-123'
  end

  def persisted?
    true
  end

  def model_name
    ActiveModel::Name.new(self.class, nil, 'Home')
  end

  # Mimics ActiveStorage::Attached::One#attachment
  def attachment
    self
  end
end

class FormaticFileTest < ApplicationTest
  test 'custom data attributes' do
    f = TestFormBuilder.for(FileModel.new)
    component = Formatic::File.new(f:, attribute_name: :the_file, data: { custom: 'value' })
    output = render_inline(component)

    file_input = output.at_css('input[type="file"]')
    refute_nil file_input, 'Expected a file input'

    assert_equal 'value', file_input['data-custom']
  end

  test 'renders a link to the existing file underneath the input' do
    attachment = FakeAttachment.new(filename: 'report.pdf', byte_size: 123,
                                    content_type: 'application/pdf')
    f = TestFormBuilder.for(FileModel.new(the_file: attachment))
    component = Formatic::File.new(f:, attribute_name: :the_file)
    output = render_inline(component)

    link = output.at_css('.c-formatic-file__current a')

    refute_nil link, 'Expected a link to the existing file'
    assert_equal 'report.pdf', link.text.strip
    assert_equal '/home', link['href']
  end

  test 'does not render a file link when multiple files are allowed' do
    attachment = FakeAttachment.new(filename: 'report.pdf', byte_size: 123,
                                    content_type: 'application/pdf')
    f = TestFormBuilder.for(FileModel.new(the_file: attachment))
    component = Formatic::Files.new(f:, attribute_name: :the_file)
    output = render_inline(component)

    assert_nil output.at_css('.c-formatic-file__current')
  end
end
