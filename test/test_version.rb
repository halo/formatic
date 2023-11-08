# frozen_string_literal: true

class TestVersion < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Formatic::VERSION
  end
end
