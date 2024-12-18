# frozen_string_literal: true

# frozen_toggle_literal: true

require 'test_helper'

class RedModel
  include ActiveModel::API

  attr_accessor :the_name
end

class TestToggle < ViewComponent::TestCase
  def test_value_without_object
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

  def test_without_object
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

  def test_class
    f = TestFormBuilder.for(RedModel.new)
    component = Formatic::Toggle.new(f:, attribute_name: :the_name, class: :flashy)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-toggle__input')

    assert_equal 'c-formatic-toggle__input flashy', text_field[:class]
  end

  def test_autofocus_deactivated
    f = TestFormBuilder.for(RedModel.new)
    component = Formatic::Toggle.new(f:, attribute_name: :the_name, autofocus: false)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-toggle__input')

    assert_nil text_field[:autofocus]
  end

  def test_autofocus_default
    f = TestFormBuilder.for(RedModel.new)
    component = Formatic::Toggle.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-toggle__input')

    assert_nil text_field[:autofocus]
  end
end
