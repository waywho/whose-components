# Whose::Components
A Rails engine with Tailwind UI components, a light and dark theme, and email-and-password auth that the gem holds. It also has a `rails new` template that sets up a new app with all of these.

## Usage
Make a new app with the app template:

```bash
rails new myapp -d postgresql --css tailwind -m https://raw.githubusercontent.com/waywho/whose-components/v0.1.0/lib/templates/whose_app_template.rb
```

The URL names a ref: a tag, a branch, or `refs/tags/<tag>` or `refs/heads/<branch>`. The gem and the template files both come from that ref. A branch name that has a slash does not work.

Add `--root pages#home` to make a root page. The template writes the route, the controller, the view and a controller test. Use any `controller#action`, for example `--root landing#show`. With sign-in, the page asks a signed-out visitor to sign in.

If you pass `--skip-bundle`, the template prints the commands that you must run by hand.

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

`whose_form_with` also takes `labels: :placeholder`. Text, email, password and other typed fields and text areas then show the label as the placeholder, and the label is visible only to screen readers. A placeholder that a field sets itself stays. Selects, file fields, checkboxes and toggles keep a visible label. The option works with all three layouts.

```haml
= whose_form_with model: @search, url: search_path, layout: :inline, labels: :placeholder do |f|
  = f.text_field :query, label: "Search"
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
The gem is not on RubyGems. Add it to your Gemfile from GitHub:

```ruby
gem "whose-components", github: "waywho/whose-components"
```

Then run:

```bash
bundle install
bin/rails generate whose:components:install
```

The install generator does these things:

- Adds `@import "../builds/tailwind/whose_components.css";` to `app/assets/tailwind/application.css`, after `@import "tailwindcss";`.
- Adds `eagerLoadControllersFrom("whose/controllers", application)` to `app/javascript/controllers/index.js`.
- Replaces `app/views/layouts/application.html.erb` with `app/views/layouts/application.html.haml`. The new layout uses the theme and renders the nav and flash components.

For email-and-password sign-in, add `--auth`:

```bash
bin/rails generate whose:components:install --auth
```

With `--auth`, the generator also does these things:

- Creates the migrations `create_users` and `create_whose_sessions`.
- Creates `app/models/user.rb`, which includes `Whose::Authenticatable`, and `test/factories/users.rb`.
- Adds `include Whose::Authentication` to `ApplicationController`.
- Adds `whose_authentication` to `config/routes.rb`. It defines the routes for `session`, `registration`, `confirmations` and `passwords`.
- Adds a sign-out button to the nav in the layout.

## Auth views
To change the auth views, copy them into your app:

```bash
bin/rails generate whose:components:views
```

The generator copies the folders `sessions`, `registrations`, `confirmations`, `passwords` and `auth_mailer` from the gem to `app/views/whose/`. Your copies replace the views of the gem.

## Auth hooks
`Whose::Authentication` is included in `ApplicationController`. Override these private methods there to change the behaviour:

| Method | Default |
| --- | --- |
| `after_sign_in_path` | `root_path` of the app, or `"/"` if the app has no root route |
| `after_sign_up_path` | `new_session_path` |
| `after_sign_out_path` | `new_session_path` |
| `sign_up_params` | `params.expect(user: %i[first_name last_name email_address password password_confirmation])` |
| `after_sign_up(user)` | Does nothing. It runs after a user signs up. |

After sign-in, a user goes back to the page that they first asked for. `after_sign_in_path` applies only when there is no such page.

Every action requires sign-in by default. To make a page public, call `allow_unauthenticated_access` in the controller:

```ruby
class PagesController < ApplicationController
  allow_unauthenticated_access only: :home
end
```

The auth flow never shows whether an email address has an account. Sign-in, sign-up, confirmation resend and password reset give the same status, page and message for a known and an unknown address.

## Theme
The theme tokens are CSS variables with the prefix `--whose-`, defined in `:root`. Dark mode redefines the colour variables under `prefers-color-scheme: dark`. The variables are:

- Colours: `--whose-canvas`, `--whose-surface`, `--whose-subtle`, `--whose-fg`, `--whose-muted`, `--whose-border`, `--whose-accent`, `--whose-on-accent`, `--whose-accent-soft`, `--whose-accent-text`
- Status colours: `--whose-positive`, `--whose-negative` and `--whose-warning`, each with a `-soft` variant
- `--whose-radius`
- Fonts: `--whose-font-sans`, `--whose-font-display`

Tailwind has a utility for each token, for example `bg-surface`, `text-fg`, `border-border` and `bg-accent`.

To change a token, set it in `app/assets/tailwind/application.css`, after the import of the gem CSS:

```css
:root {
  --whose-accent: var(--color-teal-600);
  --whose-radius: 0.75rem;
}
```

Dark mode sets its own `--whose-accent`. To change the accent in dark mode too, set it again inside `@media (prefers-color-scheme: dark)`.

## Pagination
`pagination_component(pagy: @pagy)` renders `@pagy.series_nav`, so it needs Pagy 43. The gem does not depend on Pagy. Add `gem "pagy", "~> 43"` to your Gemfile. The component renders nothing when there is only one page.

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

Code in `lib/`, such as the form builder, does not reload. After you change it, run `bin/rails restart` from the repo root in another terminal. It restarts the running server, so you do not need to stop `bin/dev`.

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
