# frozen_string_literal: true

require 'test_helper'

class TestVersion < Minitest::Test
  def test_string
    output = Formatic::Css.call('one')

    assert_equal 'one', output
  end

  def test_array
    output = Formatic::Css.call(%w[one two])

    assert_equal 'one two', output
  end

  def test_nil
    output = Formatic::Css.call([:one, 2, nil])

    assert_equal 'one 2', output
  end

  def test_array_of_arrays
    output = Formatic::Css.call([:one, :two, [:three]])

    assert_equal 'one two three', output
  end
end
