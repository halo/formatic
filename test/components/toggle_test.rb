# frozen_string_literal: true

require 'test_helper'

class RedModel
  include ActiveModel::API

  attr_accessor :the_name
end

class TestToggle < ApplicationTest
  test 'test_value_without_object' do
    f = TestFormBuilder.for(RedModel.new)
    component = Formatic::Toggle.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_field = output.at_css('.u-formatic-container ' \
                               '.c-formatic-wrapper ' \
                               '.c-formatic-wrapper__input ' \
                               '.c-formatic-toggle ' \
                               '.c-formatic-toggle__input')

    assert_equal 'the_name', text_field[:name]
  end

  test 'test_without_object' do
    f = TestFormBuilder.for(nil)
    component = Formatic::Toggle.new(f:,
                                     attribute_name: :zipcode,
                                     autofocus: true,
                                     label: false)
    output = render_inline(component)
    # p output.to_html

    text_field = output.at_css('.c-formatic-toggle__input')

    assert_equal 'zipcode', text_field[:name]
  end

  # TODO: This is common functionality that is not really associated with this input.

  test 'test_class' do
    f = TestFormBuilder.for(RedModel.new)
    component = Formatic::Toggle.new(f:, attribute_name: :the_name, class: :flashy)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-toggle__input')

    assert_equal 'c-formatic-toggle__input flashy', text_field[:class]
  end

  test 'test_autofocus_deactivated' do
    f = TestFormBuilder.for(RedModel.new)
    component = Formatic::Toggle.new(f:, attribute_name: :the_name, autofocus: false)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-toggle__input')

    assert_nil text_field[:autofocus]
  end

  test 'test_autofocus_default' do
    f = TestFormBuilder.for(RedModel.new)
    component = Formatic::Toggle.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-toggle__input')

    assert_nil text_field[:autofocus]
  end
end
