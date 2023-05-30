## v0.5.3 (2023-05-30)
### Changed
- Move from Memoist to MemoWise

## v0.5.2 (2021-02-13)
### Fixed
- Actually fix "uninitialized constant StringIO" error when running `livdoc` executable

## v0.5.1 (2021-02-13)
### Fixed
- Fix "uninitialized constant StringIO" error when running `livdoc` executable

## v0.5.0 (2021-02-06)
### Added
- Support logging multiple printed outputs
- Automatically monkeypatch `puts` to capture output

## v0.4.0 (2021-02-04)
### Added
- Render markdown preview next to web-based editor

## v0.3.0 (2021-02-04)
### Added
- Add support for evaluating Ruby code blocks within Markdown documents

## v0.2.2 (2021-02-03)
### Added
- Add ability to toggle the "Frontmatter" section in the web editor

### Internal
- Set up RSpec testing
- Add some tests for `CodeEvaluator`
- Add test coverage reporting (via `codecov` and `simplecov`)

## v0.2.1 (2021-02-03)
### Fixed
- Run `livdocweb` with Ruby (not bash)

## v0.2.0 (2021-02-03)
### Added
- Add web-based editor

## v0.1.4 (2021-01-26)
### Dependencies
- Bump `release_assistant` to `0.1.1.alpha`

## v0.1.3 (2021-01-26)
### Internal
- Move CI from Travis to GitHub Actions
- Use `release_assistant` gem to manage the release process

## v0.1.2 (2021-01-07)
### Internal
- Added `rubocop-rake` gem

## v0.1.1 (2020-07-02)
### Internal
- Source Rubocop rules/config from `runger_style` gem

## v0.1.0 (2020-06-20)
- Initial release of `living_document`!
