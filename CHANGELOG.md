# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- `publish.yml` publishes the gem to RubyGems on each `v*` tag push. The deploy key pushes the release tag, so the push starts the workflow.
- `publish.yml` also runs by hand with a tag input. This publishes `v0.3.0`, which the first publish missed.
### Changed
- `release.yml` only releases and tags. It has no publish step and no `id-token` permission.
- The publish uses `rubygems/configure-rubygems-credentials@v2.2.0` with `owner` from the `RUBYGEMS_OWNER_ID` repository variable. RubyGems needs the owner for the first push of a new gem.
### Fixed
- The first publish of `0.3.0` failed, because the workflow did not name the owner account.

## [0.3.0] - 2026-11-26
### Added
- The release workflow publishes the gem to RubyGems after each release. It uses trusted publishing, so no API key is stored.
- The gemspec has a `changelog_uri` and requires MFA for pushes.
### Changed
- The system tests use Cuprite, as `hub` does. `selenium-webdriver` is gone from the Gemfile.
- **Cause:** Capybara 3.40.0 resets each session with the CDP command `Storage.clearDataForOrigin` and `origin: "*"`. Chrome 158 rejects it with "* is not a valid URL". The fix is upstream as teamcapybara/capybara#2865, not released.
- The GitHub runner image `20261122.9.1` has Chrome 158, so every system test failed on it, also on `main`.
- The nav test resizes with `page.current_window.resize_to`. The modal test clicks outside with the Cuprite mouse.
- **Breaking:** the users column `email_address` is now `email` (#69). The params are `user[email]` and `email`. An app must rename its column and update its forms. Version 0.2.1 already had this change, but its changelog did not list it.
- A new app from the template takes the gem from RubyGems, not from GitHub.
- The README installs the gem with `gem "whose-components", "~> 0.3"`.
### Fixed
- The gem packs only files that git tracks. Before, it packed all of `vendor/`, which in CI also holds the installed gems in `vendor/bundle`.

## [0.2.1] - 2026-11-26
### Changed
- Check the version format, not one version
- `select` and `collection_select` hide the browser arrow with `appearance-none`. They draw a chevron SVG in a grid over the field.
- The field gets `pr-10`, so the text does not run under the caret.
- The caret uses `text-fg`, so it follows light and dark mode.
### Fixed
- The browser arrow sat too close to the right border.

## [0.2.0] - 2026-11-15
### Changed
- A class that you pass to a component or a form field replaces a component class that sets the same property.
- Push the release with a deploy key

### Removed
- The `data-flash-type` attribute on flash messages. Select a message by its role: `alert` for an alert, `status` for the other types.

## [0.1.0] - 2026-10-23
### Added
- Components: Badge, Button, Card, Flash, Link, List and ListRow, Modal, Nav and Nav item, Off-canvas, Page header, Pagination, Tooltip, and the form field.
- View helpers for every component, and `whose_form_with` with a form builder that wraps fields in the field component. Layouts: vertical, horizontal and inline. Labels: visible or placeholder.
- Form fields for the typed inputs, selects, checkboxes, toggles and file fields. `collection_radio_buttons` renders one radio group.
- Field error messages in plain English, which an app can change in its locale.
- A Tailwind theme with dark mode and CSS variables for brand color, fonts and radius.
- Stimulus controllers for dialogs, notifications and password visibility.
- Email-and-password auth: sign-in, sign-up, email confirmation, password reset, sessions, rate limits and mailers. The auth never shows whether an email address has an account.
- Generators: `whose:components:install [--auth]` and `whose:components:views`.
- An app template for `rails new` with the flags `--auth`, `--no-auth`, `--root controller#action` and `--component-gem-path`. It makes the first commit and prints the GitHub steps.
- `bin/install-railsrc` writes the template defaults into `~/.railsrc`.

[Unreleased]: https://github.com/waywho/whose-components/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/waywho/whose-components/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/waywho/whose-components/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/waywho/whose-components/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/waywho/whose-components/releases/tag/v0.1.0
