# frozen_string_literal: true

require 'test_helper'

class BlueModel
  include ActiveModel::API

  attr_accessor :the_name
end

class ExplanatoryModel
  include ActiveModel::API

  attr_accessor :created_at
end

class TestString < ApplicationTest
  test 'test_value_without_object' do
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

  test 'test_without_object' do
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

  test 'test_readonly' do
    f = TestFormBuilder.for(BlueModel.new(the_name: 'Static yo'))
    component = Formatic::String.new(f:, attribute_name: :the_name, readonly: true)
    output = render_inline(component)

    input_container = output.at_css('.c-formatic-string div')
    paragraph = input_container.at_css('p')

    assert_equal 'Static yo', paragraph.text.strip
  end

  # TODO: This is common functionality that is not really associated with this input.

  test 'test_autofocus' do
    f = TestFormBuilder.for(BlueModel.new)
    component = Formatic::String.new(f:, attribute_name: :the_name, autofocus: true)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-string__input')

    assert_equal 'autofocus', text_field[:autofocus]
  end

  test 'test_autofocus_deactivated' do
    f = TestFormBuilder.for(BlueModel.new)
    component = Formatic::String.new(f:, attribute_name: :the_name, autofocus: false)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-string__input')

    assert_nil text_field[:autofocus]
  end

  test 'test_autofocus_default' do
    f = TestFormBuilder.for(BlueModel.new)
    component = Formatic::String.new(f:, attribute_name: :the_name)
    output = render_inline(component)

    text_field = output.at_css('.c-formatic-string__input')

    assert_nil text_field[:autofocus]
  end

  # The Wrapper already has intensive tests for hints,
  # but the integration with the Wrapper is tested here.
  test 'test_hint' do
    I18n.with_locale(:es) do
      f = TestFormBuilder.for(ExplanatoryModel.new)
      component = Formatic::String.new(f:, attribute_name: :created_at)
      output = render_inline(component)

      hint_container = output.at_css('.c-formatic-wrapper__hint')

      assert_equal 'Behold the time.', hint_container.text.strip
    end
  end
end
