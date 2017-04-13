require 'thor'
require 'rest-client'
require 'json'
require 'terminal-table'
require 'time'

module Gitlabci
  module Controller
    class Cli < Thor
      desc "list", "List pipelines for a project"

      method_option :id, :required => true, :aliases => "-i"
      method_option :token, :required => true, :aliases => "-t"
      method_option :url, :required => true, :aliases => "-u"

      def list_pipelines
        response = RestClient::Request.execute(
                  :method => :get,
                  :headers => {"PRIVATE-TOKEN" => options[:token]},
                  :url => "#{options[:url]}/api/v3/projects/#{options[:id]}/pipelines/",
                  :verify_ssl => false,
                  :timeout => 5)

        pipelines = JSON.parse(response)

        table = Terminal::Table.new do |t|
          t.title = "Pipelines for #{options[:id]}"
          t.headings = ["Id", "Status", "Branch", "Created by", "Created at", "Finished at"]
          pipelines.each do |pipeline|
            t.add_row([
              pipeline["id"],
              pipeline["status"],
              pipeline["ref"],
              pipeline["user"]["name"],
              pipeline["created_at"],
              pipeline["finished_at"]
              ])
          end
        end

        puts table
      end

      desc "run", "Run a pipeline for a project"

      method_option :id, :required => true, :aliases => "-i"
      method_option :token, :required => true, :aliases => "-t"
      method_option :url, :required => true, :aliases => "-u"

      def run_pipeline
        response = RestClient::Request.execute(
    							:method => :get,
                  :headers => {"PRIVATE-TOKEN" => options[:token]},
    							:url => "#{options[:url]}/api/v3/projects/#{options[:id]}/pipeline?ref=master",
    							:verify_ssl => false,
    							:timeout => 10)

        data = JSON.parse(response)
        puts data
        puts data["id"]
      end

      desc "ps", "Get a pipeline status"

      method_option :id, :required => true, :aliases => "-i"
      method_option :token, :required => true, :aliases => "-t"
      method_option :url, :required => true, :aliases => "-u"

      def get_pipeline_status
        response = RestClient::Request.execute(
                  :method => :get,
                  :headers => {"PRIVATE-TOKEN" => options[:token]},
                  :url => "#{options[:url]}/api/v3/projects/#{options[:id]}/pipelines/",
                  :verify_ssl => false,
                  :timeout => 5)

        data = JSON.parse(response)
        puts data["id"]
        puts data["status"]
        #
        # i = 0
        # begin
        #   puts "#{data["status"]}, #{i} seconds ago"
        #   sleep 1
        # end while data["status"] == "running"
        #   i += 1
        #   puts "#{data["status"]}, #{i} seconds ago"
        #   sleep 1
        # end
      end

    end
  end
end
