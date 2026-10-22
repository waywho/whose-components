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

## View helpers
Each component has a view helper. The helper name is the component class name in snake case, without `Whose`. The helper takes the same arguments and block as the component.

- `button_component`, `link_component`, `badge_component`, `card_component`
- `flash_component`, `page_header_component`, `list_component`, `list_row_component`
- `modal_component`, `offcanvas_component`, `tooltip_component`
- `nav_component`, `nav_item_component`, `pagination_component`

```erb
<%= card_component do |card| %>
  <% card.with_header { "Title" } %>
  Body
<% end %>
```

`whose_form_with` wraps `form_with` and is not a component.

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

## Docs app
The `docs/` folder holds the docs app. It shows each component in Lookbook at `/lookbook`. The gem's tests also run against this app.

```bash
bin/dev
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
