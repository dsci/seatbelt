# Seatbelt

Interface for communication between the Vagalo web application and a travel data
layer.

## Development instructions

### Install RSpec Git Pre-commit hook

To get a working testsuite before committing code to the repository you have to install a Git pre-commit hook that prevends you from committing unless your specs passed or are pending.

If you haven't <code>wget</code> installed already, install it using homebrew:

```
brew install wget
```

Install the hook:

```
wget -O .git/hooks/pre-commit https://raw.github.com/markhazlett/RSpec-Pre-commit-Git-Hook/master/rspec-precommit
```

After installing, call

```
chmod +x .git/hooks/pre-commit
```

to make it executable.

### Testing

Although running the testsuite with [Guard](http://guardgem.org/) I highly recommened the
[RubyTest](http://sublimepackages.com/#/details/rubytest) Sublime Text package.


## Installation

Add this line to your application's Gemfile:

    gem 'seatbelt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seatbelt

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
