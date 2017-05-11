require "thor"
require "gitlabci/controller/pipeline"
require "gitlabci/controller/trigger"

module Gitlabci
  module Controller
    class Cli < Thor
      desc "pipeline SUBCOMMAND", "Interact the pipeline API"
      subcommand "pipeline", Pipeline

      desc "trigger SUBCOMMAND", "Interact the trigger API"
      subcommand "trigger", Trigger
    end
  end
end
