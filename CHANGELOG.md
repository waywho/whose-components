# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/waywho/whose-components/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/waywho/whose-components/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/waywho/whose-components/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/waywho/whose-components/releases/tag/v0.1.0
