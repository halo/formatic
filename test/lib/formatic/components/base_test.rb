# frozen_string_literal: true

require 'test_helper'

class BaseTest < Megatest::Test
  test '#input_name singular' do
    f = TestFormBuilder.for(RedModel.new)
    base = Formatic::Base.new(f:, attribute_name: :the_name)

    assert_equal 'red_model[the_name]', base.send(:input_name)
  end

  test '#input_name plural' do
    f = TestFormBuilder.for(RedModel.new)
    base = Formatic::Base.new(f:, attribute_name: :the_name, multiple: true)

    assert_equal 'red_model[the_name][]', base.send(:input_name)
  end
end
