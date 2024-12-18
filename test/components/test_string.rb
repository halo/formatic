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

  def test_readonly
    f = TestFormBuilder.for(BlueModel.new(the_name: 'Static yo'))
    component = Formatic::String.new(f:, attribute_name: :the_name, readonly: true)
    output = render_inline(component)

    input_container = output.at_css('.c-formatic-string div')
    paragraph = input_container.at_css('p')

    assert_equal 'Static yo', paragraph.text.strip
  end

  # TODO: This is common functionality that is not really associated with this input.

  def test_autofocus
    f = TestFormBuilder.for(BlueModel.new)
    component = Formatic::String.new(f:, attribute_name: :the_name, autofocus: true)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-string__input')

    assert_equal 'autofocus', text_field[:autofocus]
  end

  def test_autofocus_deactivated
    f = TestFormBuilder.for(BlueModel.new)
    component = Formatic::String.new(f:, attribute_name: :the_name, autofocus: false)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-string__input')

    assert_nil text_field[:autofocus]
  end

  def test_autofocus_default
    f = TestFormBuilder.for(BlueModel.new)
    component = Formatic::String.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-string__input')

    assert_nil text_field[:autofocus]
  end
end
