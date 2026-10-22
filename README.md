# Whose::Components
Short description and motivation.

## Usage
Make a new app with the app template:

```bash
rails new myapp -d postgresql --css tailwind -m https://raw.githubusercontent.com/waywho/whose-components/main/lib/templates/whose_app_template.rb
```

The template asks if the app needs sign-in. Set `WHOSE_AUTH=yes` or `WHOSE_AUTH=no` to answer without the prompt.

Set `WHOSE_GEM_PATH` to a local checkout of this gem to install the gem from that path instead of GitHub.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "whose-components"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install whose-components
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
