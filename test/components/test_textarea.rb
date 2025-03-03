# frozen_string_literal: true

require 'test_helper'

class OrangeModel
  include ActiveModel::API

  attr_accessor :the_name
end

class TestTextarea < ViewComponent::TestCase
  def test_value_without_object
    f = TestFormBuilder.for(OrangeModel.new)
    component = Formatic::Textarea.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_area = output.at_css('.u-formatic-container ' \
                              '.c-formatic-wrapper ' \
                              '.c-formatic-wrapper__input ' \
                              '.c-formatic-textarea ' \
                              '.c-formatic-textarea__input')

    assert_equal 'the_name', text_area[:name]
    assert_equal "\n", text_area.content
  end

  def test_without_object
    f = TestFormBuilder.for(nil)
    component = Formatic::Textarea.new(f:,
                                       attribute_name: :zipcode,
                                       autofocus: true,
                                       label: false,
                                       value: 'predefined')
    output = render_inline(component)

    text_area = output.at_css('.c-formatic-textarea__input')

    assert_equal 'zipcode', text_area[:name]
    assert_equal "\npredefined", text_area.content
  end

  def test_readonly
    f = TestFormBuilder.for(OrangeModel.new(the_name: 'Static yo'))
    component = Formatic::Textarea.new(f:, attribute_name: :the_name, readonly: true)
    output = render_inline(component)

    input_container = output.at_css('.c-formatic-textarea div')
    paragraph = input_container.at_css('p')

    assert_equal 'Static yo', paragraph.text.strip
  end

  # TODO: This is common functionality that is not really associated with this input.

  def test_autofocus
    f = TestFormBuilder.for(OrangeModel.new)
    component = Formatic::Textarea.new(f:, attribute_name: :the_name, autofocus: true)
    output = render_inline(component)

    text_area = output.at_css('.c-formatic-textarea__input')

    assert_equal 'autofocus', text_area[:autofocus]
  end

  def test_autofocus_deactivated
    f = TestFormBuilder.for(OrangeModel.new)
    component = Formatic::Textarea.new(f:, attribute_name: :the_name, autofocus: false)
    output = render_inline(component)

    text_area = output.at_css('.c-formatic-textarea__input')

    assert_nil text_area[:autofocus]
  end

  def test_autofocus_default
    f = TestFormBuilder.for(OrangeModel.new)
    component = Formatic::Textarea.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_area = output.at_css('.c-formatic-textarea__input')

    assert_nil text_area[:autofocus]
  end
end
