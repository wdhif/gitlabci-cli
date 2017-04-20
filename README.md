# gitlabci-controller
[![Build Status](https://travis-ci.org/wdhif/gitlabci-controller.svg?branch=master)](https://travis-ci.org/wdhif/gitlabci-controller)

Control your GitlabCI workflow from your terminal

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitlabci-controller'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitlabci-controller

## Usage

```
  gitlabci-controller help [COMMAND]                                                              # Describe available commands or one specific command
  gitlabci-controller list -i, --id=ID -t, --token=TOKEN -u, --url=URL                            # List the 20 last pipelines for a project
  gitlabci-controller get -i, --id=ID -p, --pipeline=PIPELINE -t, --token=TOKEN -u, --url=URL     # Get a pipeline status
  gitlabci-controller run -i, --id=ID -t, --token=TOKEN -u, --url=URL                             # Run a pipeline for a project
  gitlabci-controller retry -i, --id=ID -p, --pipeline=PIPELINE -t, --token=TOKEN -u, --url=URL   # Retry a failed pipeline status
  gitlabci-controller cancel -i, --id=ID -p, --pipeline=PIPELINE -t, --token=TOKEN -u, --url=URL  # cancel a running pipeline status
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wdhif/gitlabci-controller.
