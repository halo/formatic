# frozen_string_literal: true

module Formatic
  # A component that every other component inherits from in this gem.
  # It adds convenience methods for initialization of a component.
  class ApplicationComponent < ViewComponent::Base
    extend Dry::Initializer

    # By default, Dry::Initializer doesn't complain about invalid arguments.
    # We want it to raise an error.
    def initialize(...)
      __check_for_unknown_options(...)
      super
    end

    private

    def __check_for_unknown_options(*args, **kwargs)
      return if __defined_options.empty?

      # Checking params
      opts = args.drop(__defined_params.length).first || kwargs
      raise ArgumentError, "Unexpected argument #{opts}" unless opts.is_a? Hash

      # Checking options
      unknown_options = opts.keys - __defined_options
      message = "Key(s) #{unknown_options} not found in #{__defined_options}"
      raise KeyError, message if unknown_options.any?
    end

    def __defined_options
      self.class.dry_initializer.options.map(&:source)
    end

    def __defined_params
      self.class.dry_initializer.params.map(&:source)
    end
  end
end
