# frozen_string_literal: true

require 'test_helper'

class BlueModel
  include ActiveModel::API

  attr_accessor :the_name
end

class TestString < ViewComponent::TestCase
  def test_value_without_object
    f = TestFormBuilder.for(BlueModel.new)
    component = Formatic::String.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_field = output.at_css('.u-formatic-container ' \
                               '.c-formatic-wrapper ' \
                               '.c-formatic-wrapper__input ' \
                               '.c-formatic-string ' \
                               '.c-formatic-string__input')

    assert_equal 'the_name', text_field[:name]
  end

  def test_without_object
    f = TestFormBuilder.for(nil)
    component = Formatic::String.new(f:,
                                     attribute_name: :zipcode,
                                     autofocus: true,
                                     label: false,
                                     value: 'predefined')
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-string__input')

    assert_equal 'zipcode', text_field[:name]
    assert_equal 'predefined', text_field[:value]
  end
end
