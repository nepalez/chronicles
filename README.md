Chronicles
===================

[![Gem Version](https://img.shields.io/gem/v/chronicles.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/chronicles/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/chronicles.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/chronicles.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/nepalez/chronicles.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/nepalez/chronicles.svg)][inch]

[codeclimate]: https://codeclimate.com/github/nepalez/chronicles
[coveralls]: https://coveralls.io/r/nepalez/chronicles
[gem]: https://rubygems.org/gems/chronicles
[gemnasium]: https://gemnasium.com/nepalez/chronicles
[travis]: https://travis-ci.org/nepalez/chronicles
[inch]: https://inch-ci.org/github/nepalez/chronicles

Remembers invocations of object methods

Installation
------------

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem "chronicles"
```

Then execute:

```
bundle
```

Or add it manually:

```
gem install chronicles
```

Usage
-----

```ruby
class Test
  include Chronicles

  def initialize
    start_chronicles
    # ...
  end

  public    attr_reader :foo
  protected attr_reader :bar
  private   attr_reader :baz
end

test = Test.new
test.chronicles # => []

test.foo
test.chronicles # => [:foo]

test.send :bar
test.chronicles # => [:foo, :bar]

test.send :baz
test.chronicles # => [:foo, :bar, :baz]

test.foo
test.chronicles # => [:foo, :bar, :baz, :foo]

test.chronicles.clear
test.chronicles # => []
```

You can restrict chronicles by public, private or protected methods only:

```ruby
class Test
  # ...
  def initialize
    start_chronicles private: false
  end
end

test.foo       # public
test.send :bar # protected
test.send :baz # private
test.chronicles # => [:foo, :bar]
```

You can explicitly set methods to look for:

```ruby
class Test
  # ...
  def initialize
    start_chronicles only: [:bar]
  end
end

test.foo       # public
test.send :bar # protected
test.send :baz # private
test.chronicles # => [:bar]
```

Or exclude them from being registered:

```ruby
class Test
  # ...
  def initialize
    start_chronicles except: [:bar]
  end
end

test.foo       # public
test.send :bar # protected
test.send :baz # private
test.chronicles # => [:foo, :baz]
```

Or combine those conditions:

```ruby
class Test
  # ...
  def initialize
    start_chronicles protected: false, except: [:foo]
  end
end

test.foo       # public
test.send :bar # protected
test.send :baz # private
test.chronicles # => [:baz]
```

Actually, you can start chronicles after initialization and do it several times to add new methods to be looked for.

The problem is all methods included to the chronicle will be kept registered. To stop registering selected methods use the `stop_chronicles`:

```ruby
test.chronicles  # => []

test.start_chronicles only: [:foo, :bar]
test.foo
test.bar
test.baz
test.chronicles  # => [:foo, :bar]

test.start_chronicles only: :baz
test.foo
test.bar
test.baz
test.chronicles # => [:foo, :bar, :foo, :bar, :baz]

test.stop_chronicles except: :baz
test.foo
test.bar
test.baz
test.chronicles # => [:foo, :bar, :foo, :bar, :baz, :baz]
```

Compatibility
-------------

Tested under rubies compatible to API 2.0+:

* MRI 2.0+
* Rubinius (mode 2.0+)
* JRuby 9.0.0.0 (mode 2.0+)

Uses [RSpec] 3.0+ for testing and [hexx-suit] for dev/test tools collection.

[RSpec]: http://rspec.info/
[hexx-suit]: http://github.com/nepalez/hexx-suit

Contributing
------------

* Fork the project.
* Read the [STYLEGUIDE](config/metrics/STYLEGUIDE).
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version
  in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

License
-------

See the [MIT LICENSE](LICENSE).
