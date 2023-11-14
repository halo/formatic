# frozen_string_literal: true

require 'test_helper'

class BlueModel
  include ActiveModel::API

  attr_accessor :name
end

class RedFormBuilder
  def object
    BlueModel.new
  end

  def object_name
    nil
  end

  def label(_, **_args)
    'THELABEL'
  end

  def text_field(_, **_args)
    'THEFIELD'
  end
end

class TestString < ViewComponent::TestCase
  def test_value_without_object
    f = RedFormBuilder.new
    component = Formatic::String.new(f:, attribute_name: :name)
    output = render_inline(component)

    root = output.at_css('div.u-formatic-container')

    assert_equal 'THELABEL THEFIELD', root.content.squish
  end
end
