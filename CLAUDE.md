# whose-components

A Rails engine: UI components, a theme with dark mode, email-and-password
auth, and an app template for `rails new`.

## Commands

```sh
bin/rails test                         # Run the gem's tests, with the dummy app in test/dummy
bin/rails test test/components/whose/button_component_test.rb:12   # Run one test
bin/rubocop -A                         # Fix style
cd test/dummy && bin/dev               # Start the dummy app, with Lookbook at /lookbook
```

## Layout

- `app/components/whose/`: the components. Each one has a Lookbook preview in
  `test/components/previews/`.
- `app/controllers/whose/`, `app/views/whose/`: the auth controllers and views.
- `app/assets/tailwind/whose_components/engine.css`: the theme tokens.
- `lib/generators/whose/components/`: the install and views generators.
- `lib/templates/`: the app template. `lib/templates/app/` holds the files that
  the template copies into a new app, such as `CLAUDE.md.tt`.

## Rules

The rules for new apps also apply to this repo, from the Workflow section to
the end. The only difference: the Commands above replace the app commands.

@lib/templates/app/CLAUDE.md.tt
