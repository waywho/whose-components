# whose-components

A Rails engine: UI components, a theme with dark mode, email-and-password
auth, and an app template for `rails new`.

## Commands

```sh
bin/setup --skip-server                # Install gems, build the CSS, prepare the docs app database
bin/rails test                         # Run the gem's tests, with the docs app in docs/
bin/rails test test/system             # Run the system tests
bin/rails test test/components/whose/button_component_test.rb:12   # Run one test
bin/rubocop -A                         # Fix style
bin/dev                                # Start the docs app, with Lookbook at /lookbook
bin/restart                            # Restart the running docs app server, for example after a change in lib/
```

## Layout

- `app/components/whose/`: the components. Each one has a Lookbook preview in
  `test/components/previews/`.
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

@lib/templates/app/CLAUDE.md.tt
