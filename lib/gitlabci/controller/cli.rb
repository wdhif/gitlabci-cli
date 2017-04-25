require 'thor'
require 'rest-client'
require 'json'
require 'terminal-table'
require 'time'

module Gitlabci
  module Controller
    class Cli < Thor
      desc "list", "List the 20 last pipelines for a project"

      method_option :id, :required => true, :aliases => "-i"
      method_option :token, :required => true, :aliases => "-t"
      method_option :url, :required => true, :aliases => "-u"
      method_option :test, :boolean => true

      def list_pipelines
        begin
          response = RestClient::Request.execute(
                    :method => :get,
                    :headers => {"PRIVATE-TOKEN" => options[:token]},
                    :url => "#{options[:url]}/api/v3/projects/#{options[:id]}/pipelines/",
                    :verify_ssl => false,
                    :timeout => 60)

          pipelines = JSON.parse(response)
        rescue => e
          puts "API error"
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

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

      desc "get", "Get a pipeline status"

      method_option :id, :required => true, :aliases => "-i"
      method_option :token, :required => true, :aliases => "-t"
      method_option :url, :required => true, :aliases => "-u"
      method_option :pipeline, :required => true, :aliases => "-p"
      method_option :test, :boolean => true

      def get_pipeline_status(id = nil, url = nil, token = nil, pipeline = nil, output = true)
        begin
          response = RestClient::Request.execute(
                    :method => :get,
                    :headers => {"PRIVATE-TOKEN" => options[:token]},
                    :url => "#{options[:url] || url}/api/v3/projects/#{options[:id] || id}/pipelines/#{options["pipeline"] || pipeline}",
                    :verify_ssl => false,
                    :timeout => 60)

          pipeline = JSON.parse(response)
        rescue => e
          puts "API error"
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

        puts pipeline["status"] if output
        pipeline["status"]
      end

      desc "run", "Run a pipeline for a project"

      method_option :id, :required => true, :aliases => "-i"
      method_option :token, :required => true, :aliases => "-t"
      method_option :url, :required => true, :aliases => "-u"
      method_option :branch, :default => "master", :aliases => "-b"
      method_option :follow, :boolean => true, :aliases => "-f"
      method_option :test, :boolean => true

      def run_pipeline
        begin
          response = RestClient::Request.execute(
                    :method => :post,
                    :headers => {"PRIVATE-TOKEN" => options[:token]},
                    :url => "#{options[:url]}/api/v3/projects/#{options[:id]}/pipeline?ref=#{options[:branch]}",
                    :verify_ssl => false,
                    :timeout => 60)

          pipeline = JSON.parse(response)
        rescue => e
          puts "API error"
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

        if options[:follow]
          puts "Waiting for pipeline job #{pipeline["id"]} to finish"
          pipeline_status = get_pipeline_status(options["id"], options["token"], options["url"], pipeline["id"], false)
          loop do
            puts "The api is not responding, wait for next call" if pipeline_status == nil

            pipeline_status = get_pipeline_status(options["id"], options["token"], options["url"], pipeline["id"], false)
            sleep 2

            break if pipeline_status != "running" && pipeline_status != "pending" && pipeline_status != nil
          end

          if pipeline_status == "success"
            puts "\e[32mPipeline passed\e[0m"
            exit 0
          else
            puts "\e[31mPipeline ended with the status #{pipeline_status}\e[0m"
            exit 1
          end
        else
          puts "Pipeline job #{pipeline["id"]} has been started"
        end

      end

      desc "retry", "Retry a failed pipeline status"

      method_option :id, :required => true, :aliases => "-i"
      method_option :token, :required => true, :aliases => "-t"
      method_option :url, :required => true, :aliases => "-u"
      method_option :pipeline, :required => true, :aliases => "-p"
      method_option :follow, :boolean => true, :aliases => "-f"
      method_option :test, :boolean => true

      def retry_pipeline
        begin
          response = RestClient::Request.execute(
                    :method => :post,
                    :headers => {"PRIVATE-TOKEN" => options[:token]},
                    :url => "#{options[:url]}/api/v3/projects/#{options[:id]}/pipelines/#{options["pipeline"]}/retry",
                    :verify_ssl => false,
                    :timeout => 60)

          pipeline = JSON.parse(response)
        rescue => e
          puts "API error"
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

        if options[:follow]
          puts "Waiting for pipeline job #{pipeline["id"]} to finish"
          pipeline_status = get_pipeline_status(options["id"], options["token"], options["url"], pipeline["id"], false)
          loop do
            puts "The api is not responding, wait for next call" if pipeline_status == nil

            pipeline_status = get_pipeline_status(options["id"], options["token"], options["url"], pipeline["id"], false)
            sleep 2

            break if pipeline_status != "running" && pipeline_status != "pending" && pipeline_status != nil
          end

          if pipeline_status == "success"
            puts "\e[32mPipeline passed\e[0m"
            exit 0
          else
            puts "\e[31mPipeline ended with the status #{pipeline_status}\e[0m"
            exit 1
          end
        else
          puts "Pipeline job #{pipeline["id"]} has been started"
        end
      end

      desc "cancel", "Cancel a running pipeline status"

      method_option :id, :required => true, :aliases => "-i"
      method_option :token, :required => true, :aliases => "-t"
      method_option :url, :required => true, :aliases => "-u"
      method_option :pipeline, :required => true, :aliases => "-p"
      method_option :test, :boolean => true

      def cancel_pipeline
        begin
          response = RestClient::Request.execute(
                    :method => :post,
                    :headers => {"PRIVATE-TOKEN" => options[:token]},
                    :url => "#{options[:url]}/api/v3/projects/#{options[:id]}/pipelines/#{options["pipeline"]}/cancel",
                    :verify_ssl => false,
                    :timeout => 60)

          pipeline = JSON.parse(response)
        rescue => e
          puts "API error"
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

        puts "Pipeline job #{options["pipeline"]} has been canceled"
      end

    end
  end
end
