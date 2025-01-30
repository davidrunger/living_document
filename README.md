[![codecov](https://codecov.io/gh/davidrunger/living_document/branch/main/graph/badge.svg)](https://codecov.io/gh/davidrunger/living_document)

# LivingDocument

LivingDocument evaluates Ruby statements inline in your code editor, which can be particularly useful when writing examples of Ruby code for documentation purposes.

For example, if you write this in your editor...

```rb
(1..10).select(&:even?)
###
```

... then, when you save the file, it will be updated by LivingDocument to this...

```rb
(1..10).select(&:even?)
# => [2, 4, 6, 8, 10]
```

Additionally, any subsequent edits, when saved, will also be reflected. For example, if you change `even?` to `odd?` in the above example (and save the file), then LivingDocument will update the output shown in the `# =>` line, producing:

```rb
(1..10).select(&:odd?)
# => [1, 3, 5, 7, 9]
```

In other words, the special markers `###` and `# =>` tell LivingDocument to evaluate the line of code immediately above and insert the evaluated result at the position of the marker whenever the file is saved.

## Table of Contents

<!--ts-->
* [LivingDocument](#livingdocument)
   * [Table of Contents](#table-of-contents)
   * [Installation](#installation)
   * [Usage](#usage)
   * [Markdown support](#markdown-support)
   * [Time is frozen](#time-is-frozen)
   * [Development](#development)
   * [For maintainers](#for-maintainers)
   * [License](#license)

<!-- Created by https://github.com/ekalinin/github-markdown-toc -->
<!-- Added by: david, at: Wed Jan 29 07:45:21 PM CST 2025 -->

<!--te-->

## Installation

```
$ gem install living_document
```

Or, if you would like to add it to a `Gemfile`:

```rb
gem 'living_document'
```

## Usage

Put the following content into a file. For this example, we'll call it `ruby.rb`, but you can use any file path that you like.

```rb
1 + 2
###

5 / 0
###

puts('This is one great string!')
###
```

Then run `livdoc <path-to-your-file>` on your command line. In this example, that is:

```
$ livdoc ruby.rb
```

Then, go back to the file in your editor and save it. The file's content should be transformed to this:

```rb
1 + 2
# => 3

5 / 0
# => raises ZeroDivisionError

puts('This is one great string!')
# => prints "This is one great string!"
```

Then, edit the file and save it again. You'll see that the `# => ` comments are automatically and immediately updated to reflect your edits.

## Markdown support

LivingDocument can also handle Markdown code, which is especially convenient when developing
documentation with examples.

To use this functionality, simply provide a markdown document as the target file for `livdoc`, e.g.:

```
$ livdoc README.md
```

**NOTE:** Only code blocks that begin with `` ```rb `` or `` ```ruby `` will be evaluated.

For example, LivingDocument will turn this...

~~~markdown
This is how you do addition in Ruby:

```rb
2 + 3
###
```

This is how you do exponentiation in Ruby:

```ruby
2**4
###
```
~~~

...into this...

~~~markdown
This is how you do addition in Ruby:

```rb
2 + 3
# => 5
```

This is how you do exponentiation in Ruby:

```ruby
2**4
# => 16
```
~~~

## Time is frozen

NOTE: Time is frozen (using [`timecop`](https://github.com/travisjeffery/timecop)) when your code is executed. This could cause unexpected results if your code depends the `Time` being different when different lines of code execute.

To illustrate, note that `time_1` and `time_2` below are the same (which they wouldn't be, if run in a normal Ruby program).

```rb
time_1 = Time.now.iso8601(6)
# => "2025-01-29T18:54:23.134962-06:00"

time_2 = Time.now.iso8601(6)
# => "2025-01-29T18:54:23.134962-06:00"

time_2 > time_1
# => false
```

## Development

To install this gem onto your local machine from a development copy of the code, run `bundle exec
rake install`.

## For maintainers

To release a new version, run `bin/release` with an appropriate `--type` option, e.g.:

```
bin/release --type minor
```

(This uses the [`runger_release_assistant`](https://github.com/davidrunger/runger_release_assistant) gem.)

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
