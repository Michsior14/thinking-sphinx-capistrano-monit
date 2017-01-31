# ThinkingSphinx::Capistrano::Monit

Monit integration with Thinking Sphinx and CapistranoV3

## Installation

Add this line to your application's Gemfile:

    gem 'thinking-sphinx-capistrano-monit', group: :development

And then execute:

    $ bundle install

## Usage
```ruby
    # Capfile

    require 'thinking_sphinx/capistrano/monit'
```

## Dependencies
- 'capistrano', '~> 3.0', '>= 3.0.0'
- 'thinking-sphinx', '~> 3.3.0'

## Customizing Monit template

If you need change config for Monit, you can:

```
    bundle exec rails generate thinking_sphinx:capistrano:monit:template

```
and edit template in your config/deploy/templates folder.

## Contributing
Feel free to contribute.