# gitlabci-cli
[![Build Status](https://travis-ci.org/wdhif/gitlabci-cli.svg?branch=master)](https://travis-ci.org/wdhif/gitlabci-cli)

Control your GitlabCI workflow from your terminal

## Usage

```
gitlabci-cli help [COMMAND]                                                              # Describe available commands or one specific command
gitlabci-cli list -i, --id=ID -t, --token=TOKEN -u, --url=URL                            # List the 20 last pipelines for a project
gitlabci-cli get -i, --id=ID -p, --pipeline=PIPELINE -t, --token=TOKEN -u, --url=URL     # Get a pipeline status
gitlabci-cli run -i, --id=ID -t, --token=TOKEN -u, --url=URL                             # Run a pipeline for a project
gitlabci-cli retry -i, --id=ID -p, --pipeline=PIPELINE -t, --token=TOKEN -u, --url=URL   # Retry a failed pipeline status
gitlabci-cli cancel -i, --id=ID -p, --pipeline=PIPELINE -t, --token=TOKEN -u, --url=URL  # Cancel a running pipeline status
```
[Getting started on gitlab 8.X](https://github.com/wdhif/gitlabci-cli/blob/master/docs/getting-started-gitlab-8.md)  
[Getting started on gitlab 9.X](https://github.com/wdhif/gitlabci-cli/blob/master/docs/getting-started-gitlab-9.md)

## Development

1. Install the dependencies.

For CentOS
```
yum install gcc-c++ ruby-devel
```
For Ubuntu
```
apt install g++ make ruby-dev
```

2. Install the application dependencies.
```
bundle install
```

3. Run the project.
```
bundle exec gitlabci-cli help
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wdhif/gitlabci-cli.
