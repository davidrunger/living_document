[![codecov](https://codecov.io/gh/davidrunger/living_document/branch/master/graph/badge.svg)](https://codecov.io/gh/davidrunger/living_document)
[![Build Status](https://travis-ci.com/davidrunger/living_document.svg?branch=master)](https://travis-ci.com/davidrunger/living_document)

# LivingDocument

Validate the "shape" of Ruby objects!

# Table of Contents

<!--ts-->
<!--te-->

# Installation

The best/easiest way to install this gem is via
[`specific_install`](https://github.com/rdp/specific_install):

```
$ gem install specific_install
$ gem specific_install davidrunger/living_document
```

# Usage

```
$ livdoc ruby_playground.rb
```

# Development

To install this gem onto your local machine from a development copy of the code, run `bundle exec
rake install`.

# For maintainers

To release a new version:
1. check out the `master` branch
2. update `CHANGELOG.md`
3. update the version number in `version.rb`
4. `bundle install` (which will update `Gemfile.lock`)
5. commit the changes with a message like `Prepare to release v0.1.1`
6. push the changes to `origin/master` (GitHub) via `git push`
7. run `bin/release`, which will create a git tag for the version and push git commits and tags

# License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
