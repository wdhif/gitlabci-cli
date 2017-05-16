require 'json'
require 'rest-client'
require 'terminal-table'
require 'thor'
require 'time'

require 'gitlabci/controller/helper'

module Gitlabci
  module Controller
    # Pipeline API Class
    class Pipeline < Thor
      desc 'list', 'List the 20 last pipelines for a project'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :test, boolean: true

      def list_pipelines
        begin
          response = RestClient::Request.execute(
            method: :get,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            url: "#{options[:url]}/api/v4/projects/#{options[:id]}/pipelines/",
            verify_ssl: false,
            timeout: 60
          )

          pipelines = JSON.parse(response)
        rescue => e
          puts 'API error'
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

        table = Terminal::Table.new do |t|
          t.title = "Pipelines for #{options[:id]}"
          t.headings = %w[Id Status Branch]
          pipelines.each do |pipeline|
            t.add_row(
              [
                pipeline['id'],
                pipeline['status'],
                pipeline['ref']
              ]
            )
          end
        end
        puts table
      end

      desc 'get', 'Get a pipeline status'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :pipeline, required: true, aliases: '-p'
      method_option :test, boolean: true

      def get_pipeline_status(id = nil, url = nil, _token = nil, pipeline = nil, output = true)
        # Arguments are used when I call the get_pipeline_status method from the run_pipeline method.
        begin
          response = RestClient::Request.execute(
            method: :get,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            url: "#{options[:url] || url}/api/v4/projects/#{options[:id] || id}/pipelines/#{options[:pipeline] || pipeline}",
            verify_ssl: false,
            timeout: 60
          )

          pipeline = JSON.parse(response)
        rescue => e
          puts 'API error'
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end
        puts pipeline['status'] if output
        pipeline['status']
      end

      desc 'run', 'Run a pipeline for a project'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :branch, default: 'master', aliases: '-b'
      method_option :follow, boolean: true, aliases: '-f'
      method_option :test, boolean: true

      def run_pipeline
        begin
          response = RestClient::Request.execute(
            method: :post,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            payload: { 'ref' => options[:branch] },
            url: "#{options[:url]}/api/v4/projects/#{options[:id]}/pipeline",
            verify_ssl: false,
            timeout: 60
          )

          pipeline = JSON.parse(response)
        rescue => e
          puts 'API error'
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

        if options[:follow]
          Gitlabci::Controller::Helper.follow(options, pipeline)
        else
          puts "Pipeline job #{pipeline['id']} has been started."
        end
      end

      desc 'retry', 'Retry a failed pipeline status'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :pipeline, required: true, aliases: '-p'
      method_option :follow, boolean: true, aliases: '-f'
      method_option :test, boolean: true

      def retry_pipeline
        begin
          response = RestClient::Request.execute(
            method: :post,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            url: "#{options[:url]}/api/v4/projects/#{options[:id]}/pipelines/#{options['pipeline']}/retry",
            verify_ssl: false,
            timeout: 60
          )

          pipeline = JSON.parse(response)
        rescue => e
          puts 'API error'
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

        if options[:follow]
          Gitlabci::Controller::Helper.follow(options, pipeline)
        else
          puts "Pipeline job #{pipeline['id']} has been started."
        end
      end

      desc 'cancel', 'Cancel a running pipeline status'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :pipeline, required: true, aliases: '-p'
      method_option :test, boolean: true

      def cancel_pipeline
        begin
          RestClient::Request.execute(
            method: :post,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            url: "#{options[:url]}/api/v4/projects/#{options[:id]}/pipelines/#{options['pipeline']}/cancel",
            verify_ssl: false,
            timeout: 60
          )
        rescue => e
          puts 'API error'
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end
        puts "Pipeline job #{options['pipeline']} has been canceled."
      end
    end
  end
end
