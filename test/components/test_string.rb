# frozen_string_literal: true

require 'test_helper'

class BlueModel
  include ActiveModel::API

  attr_accessor :name
end

class RedFormBuilder
  include ActionView::Helpers::FormTagHelper

  def object
    BlueModel.new
  end

  def object_name
    nil
  end

  def label(_, **_args)
    'THELABEL'
  end

  def text_field(attribute_name, **)
    text_field_tag(attribute_name, nil, **)
  end
end

class TestString < ViewComponent::TestCase
  def test_value_without_object
    component = Formatic::String.new(f: RedFormBuilder.new, attribute_name: :the_name)
    output = render_inline(component)

    text_field = output.at_css('.u-formatic-container ' \
                               '.c-formatic-wrapper ' \
                               '.c-formatic-wrapper__input ' \
                               '.c-formatic-string ' \
                               '.c-formatic-string__input')

    assert_equal 'the_name', text_field[:name]
  end
end
