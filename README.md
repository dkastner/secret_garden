# SecretGarden

You have a [12 factor app](http://12factor.net/). You want to [configure it
using environment variables](http://12factor.net/config). But you don't want the
world to know your secrets. Or, better yet, you want your secrets to have
limited-time access.

What you really want is a way to be able to configure your app via the
envornment, but fall back to a secret storage service like
[vault](https://www.vaultproject.io/)!

This gem does just that.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'secret_garden'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secret_garden

## Usage

First, define a `Secretfile` for your project that maps environment variable
names to secret key paths in your vault:

```
# Secretfile
AWS_ACCESS_KEY_ID     secrets/services/aws:id
AWS_ACCESS_KEY_SECRET secrets/services/aws:secret
```

In your app, instead of always consulting `ENV['AWS_ACCESS_KEY_ID]`, you can use
SecretGarden:

``` ruby
# In future we will move each backend out to a gem, so that you don't need to
# download a million gems like you do with Fog.
require 'secret_garden/vault'

SecretGarden.add_backend :vault

s3 = AWS::S3.new access_key_id: SecretGarden.fetch('AWS_ACCESS_KEY_ID')
```

### In Rails

Your app may need certain environment variables that should fall back to being
read from vault if not set, such as DATABASE_URL. Simply modify
config/application.rb to pre-load them:

``` ruby
# config/application.rb
require File.expand_path('../boot', __FILE__)
require File.expand_path('../preinitialize', __FILE__)

require "rails"
# etc ...
```

``` ruby
# config/preinitialize.rb
require 'secret_garden'
require 'vault'

SecretGarden.export 'DATABASE_URL'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dkastner/secret_garden.

