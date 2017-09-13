require 'thor'

require 'gitlabci/controller/helper'
require 'gitlabci/controller/pipeline'
require 'gitlabci/controller/trigger'

module Gitlabci
  module Controller
    # Main CLI Class, with subcommands
    class Cli < Thor
      # RestClient.log = 'stdout'

      desc 'pipeline SUBCOMMAND', 'Interact the pipeline API'
      subcommand 'pipeline', Pipeline

      desc 'trigger SUBCOMMAND', 'Interact the trigger API'
      subcommand 'trigger', Trigger
    end
  end
end
