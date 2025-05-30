## Unreleased
[no unreleased changes yet]

## v2.1.0 (2025-02-05)
- Offer to create the provided target file, if it doesn't yet exist.
- Document compatibility with VS Code and NeoVim.
- Automatically open the target file in editor, if `$EDITOR` is set.

## v2.0.0 (2025-02-05)
- **BREAKING:** Use `rb-inotify` (not `listen`) to watch for file changes. This means that the gem is now only compatible with Linux.
- Support listening to files outside of the current directory.

## v1.1.1 (2025-01-30)
- Fix exception when evaluating an empty target file. https://github.com/davidrunger/living_document/pull/608

## v1.1.0 (2025-01-29)
- Support `-h`/`--help` and `-v`/`--version` CLI flags.

## v1.0.0 (2025-01-29)
- **BREAKING:** Remove web server functionality.
- **BREAKING:** Freeze time with `timecop` when executing code.
- **BREAKING:** Make target file customizable (and require a target argument for the CLI).
- Release via RubyGems.

## v0.8.0 (2024-12-10)
- Remove upper bounds on versions for all dependencies.

## v0.7.0 (2024-06-28)
- Enforce only major and minor parts of required Ruby version (loosening the required Ruby version from 3.3.3 to 3.3.0)

## v0.6.0 (2024-06-15)
- Renamed primary branch from `master` to `main`

## v0.5.4 (2023-05-30)
### Changed
- Update dependencies

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
