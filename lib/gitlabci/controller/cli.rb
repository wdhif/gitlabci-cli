require "thor"
require "gitlabci/controller/pipeline"

module Gitlabci
  module Controller
    class Cli < Thor
      desc "pipeline SUBCOMMAND", "Interact the pipeline API"
      subcommand "pipeline", Pipeline

      desc "trigger SUBCOMMAND", "Interact the trigger API"
      subcommand "trigger", Pipeline
    end
  end
end
