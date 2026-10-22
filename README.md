# Whose::Components
Short description and motivation.

## Usage
Make a new app with the app template:

```bash
rails new myapp -d postgresql --css tailwind -m https://raw.githubusercontent.com/waywho/whose-components/main/lib/templates/whose_app_template.rb
```

The template asks if the app needs sign-in. Set `WHOSE_AUTH=yes` or `WHOSE_AUTH=no` to answer without the prompt.

Set `WHOSE_GEM_PATH` to a local checkout of this gem to install the gem from that path instead of GitHub.

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

## Development
The `docs/` folder holds the docs app. It shows each component in Lookbook, and the gem's tests run against it.

### What you need
- Ruby 3.4.7, the version that CI uses.
- Google Chrome, for the system tests.

### First setup
```bash
git clone git@github.com:waywho/whose-components.git
cd whose-components
bin/setup
```

`bin/setup` installs the gems, builds the Tailwind CSS, prepares the docs app database and then starts `bin/dev`. Add `--skip-server` to stop before the server starts. Add `--reset` to empty the database and load the schema again.

### Run the docs app
```bash
bin/dev
```

This starts the server and the Tailwind watcher on port 3000.

- `http://localhost:3000` is the docs home page.
- `http://localhost:3000/lookbook` shows each component.
- Mail in development opens in the browser with `letter_opener`.

### Run the tests
```bash
bin/rails test                 # The unit, component, controller and integration tests
bin/rails test test/system     # The system tests, in headless Chrome
bin/rubocop -A                 # Style
```

The tests read the built Tailwind CSS. `bin/setup` and `bin/dev` build it. Without `bin/dev`, run `bin/rails app:tailwindcss:build` after you change a class.

### After you pull
Run `bin/setup --skip-server`. It installs new gems, builds the CSS and runs new migrations.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
