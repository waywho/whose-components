# whose-components

A Rails engine: UI components, a theme with dark mode, email-and-password
auth, and an app template for `rails new`.

## Purpose

The gem has one job: it gives UI components that an app assembles into its
pages. The app owns its data and its server side: models, controllers, jobs,
routes and streaming.

- The auth is the one exception to this rule. No new feature adds models,
  controllers, jobs or routes to the gem.
- No component renders a whole screen or feature, such as a full chat. The gem
  gives the parts, and the app puts them together.

## Commands

```sh
bin/setup --skip-server                # Install gems, build the CSS, prepare the docs app database
bin/rails test                         # Run the gem's tests, with the docs app in docs/
bin/rails test test/system             # Run the system tests
bin/rails test test/components/whose/button_component_test.rb:12   # Run one test
bin/rails generate whose:component Message --stimulus   # Add Whose::MessageComponent
bin/rubocop -A                         # Fix style
bin/dev                                # Start the docs app, with Lookbook at /lookbook
bin/rails restart                      # Restart the running docs app server, for example after a change in lib/
```

## Layout

- `app/components/whose/`: the components. Each one has a Lookbook preview in
  `test/components/previews/`.
- `app/javascript/whose/controllers/`: the Stimulus controllers.
- `docs/lib/generators/whose/`: the `whose:component` and `whose:stimulus`
  generators. They are in the docs app, so the gem does not ship them to apps.
- `app/controllers/whose/`, `app/views/whose/`: the auth controllers and views.
- `app/assets/tailwind/whose_components/engine.css`: the theme tokens.
- `lib/generators/whose/components/`: the install and views generators.
- `docs/`: the docs app. The tests run against it, and it serves Lookbook.
  Code that only the tests use goes in `test/support/`, not in `docs/`.
- `lib/templates/`: the app template. `lib/templates/app/` holds the files that
  the template copies into a new app, such as `CLAUDE.md.tt`.

## Rules

The rules for new apps also apply to this repo, from the Workflow section to
the end. The only difference: the Commands above replace the app commands.

### Components

- Add each component with `bin/rails generate whose:component <Name>`. It
  takes every ViewComponent flag, such as `--locale`, `--call` and `--inline`.
  `--stimulus` adds a controller in `app/javascript/whose/controllers/`.
- Name a component `Whose::<Name>Component`. Use no third namespace level,
  such as `Whose::Chat::MessageComponent`. The only exceptions are sub-parts
  that exist only inside one component, such as `Whose::Nav::ItemComponent`.
- A component raises `ArgumentError` for an unknown value of a choice, such as
  a variant, a size or a placement.
- A component uses only the theme classes from `engine.css`, such as
  `bg-surface` and `text-muted`. Never use a Tailwind palette color, such as
  `bg-stone-200`.
- When only some components need a gem, such as Pagy, the gem does not depend
  on it. The app adds it, and the component raises a clear error without it.

### Behaviour and JavaScript

For a behaviour, use the first of these three that does the job in current
Chrome, Safari and Firefox. Go to the next one only when you can name the
browser or the case where the one before fails.

1. HTML and CSS, such as `<details>`, `<dialog>` or the `popover` attribute.
2. A Stimulus Components package (`@stimulus-components/*`).
3. Your own Stimulus controller.

To add a Stimulus Components package:

- Pin it in `docs/` with `bin/importmap pin`.
- Move the file to `vendor/javascript/`, and keep its license header.
- Move its pin line to `config/importmap.rb`.
- Wrap it in `app/javascript/whose/controllers/whose_<name>_controller.js`, so
  apps use only `whose-*` identifiers.

### Auth

- The auth is optional. An app with no `User` model and no
  `include Whose::Authentication` boots and renders components, and the engine
  adds no routes until the app calls `whose_authentication`.
- The auth flow never shows whether an email address has an account. Sign-in,
  sign-up, confirmation resend and password reset give the same status, page
  and message for a known and an unknown address.

### Pull requests

- A pull request description uses the headings from
  `.github/pull_request_template.md`. A pull request that releases gets
  exactly one `major`, `minor` or `patch` label. A pull request that does not
  release gets no release label.

@lib/templates/app/CLAUDE.md.tt
