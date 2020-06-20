[![codecov](https://codecov.io/gh/davidrunger/living_document/branch/master/graph/badge.svg)](https://codecov.io/gh/davidrunger/living_document)
[![Build Status](https://travis-ci.com/davidrunger/living_document.svg?branch=master)](https://travis-ci.com/davidrunger/living_document)

# LivingDocument

Evaluate Ruby statements inline while you edit the file! Great for creating documentation examples!

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

Put this content into a file called `personal/ruby.rb`:

```rb
# frozen_string_literal: true

# rubocop:disable Lint/MissingCopEnableDirective,  Lint/RedundantCopDisableDirective, Lint/Void

def puts(printed_value)
  $printed_objects << printed_value
end

############

1 + 2
###

5 / 0
###

puts('This is one great string!')
###
```

The `###` things mean "insert the evaluated result of the above line of code here".

Then run this on your command line:

```
$ livdoc personal/ruby.rb
```

Then go back to `personal/ruby.rb` in your editor and save the file. It should be transformed to
this:

```rb
# frozen_string_literal: true

# rubocop:disable Lint/MissingCopEnableDirective,  Lint/RedundantCopDisableDirective, Lint/Void

def puts(printed_value)
  $printed_objects << printed_value
end

############

1 + 2
# => 3

5 / 0
# => raises ZeroDivisionError

puts('This is one great string!')
# => prints "This is one great string!"
```

Then edit the file, save it, and see that the `# => ` comments are automatically and immediately
updated! Keep rinsing and repeating!

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
