[![codecov](https://codecov.io/gh/davidrunger/living_document/branch/master/graph/badge.svg)](https://codecov.io/gh/davidrunger/living_document)

# LivingDocument

LivingDocument evaluates Ruby statements inline (either in your code editor or in the provided
web-based editor). This is great for creating documentation examples.

For example, if you write this in your editor...

```rb
(1..10).select { |integer| integer.even? }
###
```

...then when you save the file, it will be updated by LivingDocument to this...

```rb
(1..10).select { |integer| integer.even? }
# => [2, 4, 6, 8, 10]
```

Subsequent edits, when saved, will automatically update the `# =>` result output line.

In other words, the special markers `###` and `# =>` tell LivingDocument to evaluate the line of
code immediately above and insert the evaluated result at the position of the marker whenever the
file is saved (or, if using the web-based editor, whenever the user hits `Cmd + Enter`).

# Table of Contents

<!--ts-->
   * [LivingDocument](#livingdocument)
   * [Table of Contents](#table-of-contents)
   * [Installation](#installation)
   * [Usage](#usage)
      * [Via your own text editor](#via-your-own-text-editor)
      * [Via web-based editor](#via-web-based-editor)
         * [Why?](#why)
         * [How?](#how)
   * [Development](#development)
   * [For maintainers](#for-maintainers)
   * [License](#license)

<!-- Added by: david, at: Wed Feb  3 08:09:54 PST 2021 -->

<!--te-->

# Installation

The best/easiest way to install this gem is via
[`specific_install`](https://github.com/rdp/specific_install):

```
$ gem install specific_install
$ gem specific_install davidrunger/living_document
```

# Usage

## Via your own text editor

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

Then run this on your command line:

```
$ livdoc
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

Then edit the file, save it again, and see that the `# => ` comments are automatically and
immediately updated! Keep rinsing and repeating!

## Via web-based editor

### Why?

One issue with using LivingDocument to update code in your own editor is that, when editing a large
amount of code (more than fits onto the screen at once), the approach of simply writing an updated
version of the file can cause the scroll position of the document to change whenever saving a change
to the file (e.g. if you are scrolled to the bottom of the document, then you might be scrolled back
up to the top of the document whenever you save the file). Using the web-based LivingDocument editor
lessens this problem (although it introduces a different problem, which is a lack of syntax
highlighting in the web-based editor).

### How?

To run the LivingDocument server, run:

```
$ livdocweb
```

This will boot up a [`sinatra`][sinatra] server; which you can access at
[http://localhost:4567/](http://localhost:4567/). Hit `Cmd + Enter`. You'll see that the sample code
is executed. Edit the code, hit `Cmd + Enter` again, and you'll see that the result is again updated
inline.

You can put any code that you want to be executed but which you'd like to keep separate from the
main section of code (for example, any necessary `require` statements) in the **Frontmatter**
section. This code will be evaluated before the code in the main **Code** section.

[sinatra]: http://sinatrarb.com/

# Development

To install this gem onto your local machine from a development copy of the code, run `bundle exec
rake install`.

# For maintainers

To release a new version, run `bin/release` with an appropriate `--type` option, e.g.:

```
bin/release --type minor
```

(This uses the `release_assistant` gem.)

# License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
