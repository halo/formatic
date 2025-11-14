# frozen_string_literal: true

require 'test_helper'

class CssTest < Megatest::Test
  test 'test_string' do
    output = Formatic::Css.call('one')

    assert_equal 'one', output
  end

  test 'test_array' do
    output = Formatic::Css.call(%w[one two])

    assert_equal 'one two', output
  end

  test 'test_nil' do
    output = Formatic::Css.call([:one, 2, nil])

    assert_equal 'one 2', output
  end

  test 'test_array_of_arrays' do
    output = Formatic::Css.call([:one, :two, [:three]])

    assert_equal 'one two three', output
  end
end
