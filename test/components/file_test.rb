# frozen_string_literal: true

require 'test_helper'

class FileModel
  include ActiveModel::API

  attr_accessor :the_file
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
end
