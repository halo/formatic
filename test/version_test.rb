# frozen_string_literal: true

class VersionTest < Megatest::Test
  test 'test_that_it_has_a_version_number' do
    refute_nil ::Formatic::VERSION
  end
end
