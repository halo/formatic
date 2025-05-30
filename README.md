# Formatic

Opinionated ViewComponents for building forms.

## Usage

```ruby
# In Rails view
= render Formatic::String.new(f:, attribute_name: :first_name)
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    bundle add formatic

If bundler is not being used to manage dependencies, install the gem by executing:

    gem install formatic

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/ci` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Testing

Run one test individually with:

    bundle exec ruby -I test test/lib/wrappers/test_required.rb

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/halo/formatic.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
