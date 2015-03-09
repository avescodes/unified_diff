# unified_diff

[![Gem Version](http://img.shields.io/gem/v/unified_diff.svg)][gem]
[![Build Status](http://img.shields.io/travis/rkneufeld/unified_diff.svg)][travis]

[gem]: https://rubygems.org/gems/unified_diff
[travis]: http://travis-ci.org/rkneufeld/unified_diff

unified_diff is a simple library to parse unified diffs into clean ruby objects.

Simply `UnifiedDiff.parse(diff_contents)` and you'll get back a `Diff` object with metadata from your diff as well as a list of chunks accesible via `Diff#chunks`.

More features to follow.

## Contributing to unified_diff

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2015 Ryan Neufeld. See LICENSE.txt for
further details.
