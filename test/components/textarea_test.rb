# frozen_string_literal: true

require 'test_helper'

class OrangeModel
  include ActiveModel::API

  attr_accessor :the_name
end

class TestTextarea < ApplicationTest
  test 'value withoutobject' do
    f = TestFormBuilder.for(OrangeModel.new)
    component = Formatic::Textarea.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_area = output.at_css('.u-formatic-container ' \
                              '.c-formatic-wrapper ' \
                              '.c-formatic-wrapper__input ' \
                              '.c-formatic-textarea ' \
                              '.c-formatic-textarea__input')

    assert_equal 'the_name', text_area[:name]
    assert_equal '', text_area.content
  end

  test 'without object' do
    f = TestFormBuilder.for(nil)
    component = Formatic::Textarea.new(f:,
                                       attribute_name: :zipcode,
                                       autofocus: true,
                                       label: false,
                                       value: 'predefined')
    output = render_inline(component)

    text_area = output.at_css('.c-formatic-textarea__input')

    assert_equal 'zipcode', text_area[:name]
    assert_equal 'predefined', text_area.content
  end

  test 'readonly' do
    f = TestFormBuilder.for(OrangeModel.new(the_name: 'Static yo'))
    component = Formatic::Textarea.new(f:, attribute_name: :the_name, readonly: true)
    output = render_inline(component)

    input_container = output.at_css('.c-formatic-textarea div')
    paragraph = input_container.at_css('p')

    assert_equal 'Static yo', paragraph.text.strip
  end

  # TODO: This is common functionality that is not really associated with this input.

  test 'autofocus' do
    f = TestFormBuilder.for(OrangeModel.new)
    component = Formatic::Textarea.new(f:, attribute_name: :the_name, autofocus: true)
    output = render_inline(component)

    text_area = output.at_css('.c-formatic-textarea__input')

    assert_equal 'autofocus', text_area[:autofocus]
  end

  test 'autofocus_deactivated' do
    f = TestFormBuilder.for(OrangeModel.new)
    component = Formatic::Textarea.new(f:, attribute_name: :the_name, autofocus: false)
    output = render_inline(component)

    text_area = output.at_css('.c-formatic-textarea__input')

    assert_nil text_area[:autofocus]
  end

  test 'autofocus_default' do
    f = TestFormBuilder.for(OrangeModel.new)
    component = Formatic::Textarea.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_area = output.at_css('.c-formatic-textarea__input')

    assert_nil text_area[:autofocus]
  end
end
