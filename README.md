[![Gem Version](https://badge.fury.io/rb/proc_extensions.png)](http://badge.fury.io/rb/proc_extensions)
[![Build Status](https://travis-ci.org/dwhelan/proc_extensions.png?branch=master)](https://travis-ci.org/dwhelan/proc_extensions)
[![Code Climate](https://codeclimate.com/github/dwhelan/proc_extensions/badges/gpa.svg)](https://codeclimate.com/github/dwhelan/proc_extensions)
[![Coverage Status](https://coveralls.io/repos/dwhelan/proc_extensions/badge.svg?branch=master&service=github)](https://coveralls.io/github/dwhelan/proc_extensions?branch=master)

### ProcSource Class

The gem includes the `ProcSource` class which provides
access to the proc extensions without monkey patching the `Proc` class itself.

You can create a `ProcSource` with either a proc as a parameter or by passing a block to `ProcSource`.

```ruby
p = proc { |a| a.to_s }


ps1 = ProcSource.new p
ps2 = ProcSource.new { |b| b.to_s }
```

You can use the `raw_source` method to return the original source and
the  `source` method to return the *sanitized* version of the source.

```ruby
ps1.source     # => "proc { |a| a.to_s }"
ps1.raw_source # => "proc { |a| a.to_s }"
ps1.to_s       # => "proc { |a| a.to_s }"
ps1.inspect    # => "proc { |a| a.to_s }"

ps1 == ps2     # => false
ps1.match ps2  # => true
```

# Proc Extensions

Extensions to Proc support source extraction and comparison.

Optionsally methods can be added to the `Proc` class:
 * `inspect`: returns source code if it can be extracted
 * `source`, `raw_source`: returns source code
 * `==`: determines if two procs have exactly the same source code
 * `match`, `=~`: determines if two procs have the source code allowing for different parameter names

The above methods are not automatically included into the `Proc` class.
You need to explicitly include modules included in this gem.

**Note** This gem uses the [sourcify](https://github.com/ngty/sourcify) gem to extact proc source code. The `sourcify` gem
is no longer supported although it works as needed for the `proc_extensions` gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'proc_extensions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proc_extensions

## Usage

```
require proc_extensions
```

### Extensions to the Proc class

#### inspect Method

The `inspect` methods is added to `Proc` when `ProcExtensions::Inspect` is included with `Proc`:

```ruby
Proc.include ProcExtensions::Inspect
```

The `inspect` method will return the source code for the proc.

```ruby
p = proc { |a| a.to_s }
l = lambda { |a| a.to_s }

p.inspect # => "proc { |a| a.to_s }"
l.inspect # => "lambda { |a| a.to_s }"
```

If the source code cannot be extracted then the original `Proc#inspect` method will be called:

```ruby
# Can't get source if multiple procs declared on the same line
p = proc { proc {} }
p.inspect # => "#<Proc:0x007fe72b879b90>"
```

#### source Methods

The `source` and `raw_source` methods are added to `Proc` when `ProcExtensions::Source` is included with `Proc`:

```ruby
Proc.include ProcExtensions::Source
```

The `Proc#source` method will return the source code for the Proc with
white space and comments removed. The `raw_source` method will return the original source.

```ruby
p = proc { | a |  a.to_s  }
p.source # "proc { |a| a.to_s }"
p.raw_source # "proc { | a |  a.to_s  }"
```
Lambda source will have the prefix 'lambda' rather than 'proc':

```ruby
l = lambda { |a| a.to_s }
l.source # "lambda { |a| a.to_s }"
```

If the source cannot be extracted then an exception will be raised by the `sourcify` gem.

#### match Methods

The `match` and `=~` methods are added to `Proc` when `ProcExtensions::Match` is included with `Proc`:

```ruby
Proc.include ProcExtensions::Match
```

The `match(other)` method will return `true` if the procs are the same proc or
if the two procs have the same source code. The `=~` method is created as an alias for `match`.

```ruby
proc1 = proc {}
proc2 = proc {}
proc3 = proc { |a| a.to_s }

proc1.match(proc2) # => true
proc1.match(proc3) # => false

proc1 =~ proc2     # => true
proc1 =~ proc3     # => false
```

The source code for two procs are considered equal if they have the same body
even with different parameter names:

```ruby
proc1 = proc { |a| a.to_s }
proc2 = proc { |b| b.to_s }

proc1.match(proc2) # => true
```

If the procs are created via `&:method` then they will
be considered equal if they reference the same method:

```ruby
proc1 = proc(&:to_s)
proc2 = proc(&:to_s)
proc3 = proc(&:to_a)

proc1.match(proc2) # => true
proc1.match(proc3) # => false
```

If the source code cannot be extracted from either proc then `false` will be returned:

```ruby
# Can't get source if multiple procs declared on the same line
proc1 = proc { proc {} }
proc2 = proc { proc {} }

proc1.match(proc2) # => false
```

## Ruby Versions Supported

* 1.9.3
* 2.0
* 2.1
* 2.2

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dwhelan/proc_extensions.
This project is intended to be a safe, welcoming space for collaboration, 
and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) 
code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
