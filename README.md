# Whose::Components
Short description and motivation.

## Usage
Make a new app with the app template:

```bash
rails new myapp -d postgresql --css tailwind -m https://raw.githubusercontent.com/waywho/whose-components/main/lib/templates/whose_app_template.rb
```

The template asks if the app needs sign-in. Set `WHOSE_AUTH=yes` or `WHOSE_AUTH=no` to answer without the prompt.

Set `WHOSE_GEM_PATH` to a local checkout of this gem to install the gem from that path instead of GitHub.

## Form layouts
`whose_form_with` takes a `layout:` option. An unknown layout raises `ArgumentError`.

- `:vertical` (default): each label sits above its input, and the fields stack.
- `:horizontal`: each label sits beside its input. On a phone the label moves above.
- `:inline`: the fields and the submit button sit side by side in one row. Labels stay above the inputs. On a phone the row becomes a stack.

```haml
= whose_form_with model: @search, url: search_path, layout: :inline do |f|
  = f.text_field :query
  = f.submit "Search"
```

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
