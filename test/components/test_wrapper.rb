# frozen_string_literal: true

class RocketModel
  include ActiveModel::API
end

class RocketModelPolicy < ActionPolicy::Base
  def new?
    user == :yes
  end
end

class TestWrapper < ViewComponent::TestCase
  def test_disallowed
    model = RocketModel.new
    current_user = :no

    component = Formatic::Wrapper.new(url: :home, model:, current_user:)
    ouput = render_inline(component) { 'Hello, World!' }

    assert_equal('Hello, World!', ouput.to_html)
  end

  def test_allowed
    model = RocketModel.new
    current_user = :yes

    component = Formatic::New.new(url: :home, model:, current_user:)
    ouput = render_inline(component) { 'Hello, World!' }

    expected_html = <<~HTML.strip
      <a title="Add Rocket model" class="c-action-link " href="/home">Hello, World! <i class="o-acticon o-acticon--plus-circle"></i></a>
    HTML
    assert_equal(expected_html, ouput.to_html)
  end

  def test_extra_options
    model = RocketModel.new
    current_user = :yes

    component = Formatic::New.new(url: :home, model:, current_user:, data: { cool: :thing })
    ouput = render_inline(component) { 'Hello, World!' }

    expected_html = <<~HTML.strip
      <a title="Add Rocket model" class="c-action-link " data-cool="thing" href="/home">Hello, World! <i class="o-acticon o-acticon--plus-circle"></i></a>
    HTML
    assert_equal(expected_html, ouput.to_html)
  end
end
