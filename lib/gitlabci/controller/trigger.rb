require 'json'
require 'rest-client'
require 'terminal-table'
require 'thor'
require 'time'

require 'gitlabci/controller/helper'

module Gitlabci
  module Controller
    # Trigger API Class
    class Trigger < Thor
      desc 'list', 'List the triggers for a project'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :test, boolean: true

      def list_triggers
        begin
          response = RestClient::Request.execute(
            method: :get,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            url: "#{options[:url]}/api/v4/projects/#{options[:id]}/triggers",
            verify_ssl: false,
            timeout: 60
          )

          triggers = JSON.parse(response)
        rescue => e
          puts 'API error'
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

        table = Terminal::Table.new do |t|
          t.title = "Triggers for #{options[:id]}"
          t.headings = ['Id', 'Token', 'Description', 'Created by', 'Created at', 'Last used']
          triggers.each do |trigger|
            t.add_row(
              [
                trigger['id'],
                trigger['token'],
                trigger['description'],
                trigger['owner']['name'],
                trigger['created_at'],
                trigger['last_used']
              ]
            )
          end
        end
        puts table
      end

      desc 'create', 'Create a trigger'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :description, required: true, aliases: '-d'
      method_option :test, boolean: true

      def create_trigger
        begin
          response = RestClient::Request.execute(
            method: :post,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            payload: { 'description' => options[:description] },
            url: "#{options[:url]}/api/v4/projects/#{options[:id]}/triggers",
            verify_ssl: false,
            timeout: 60
          )

          trigger = JSON.parse(response)
        rescue => e
          puts 'API error'
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end
        puts "Trigger #{trigger['id']} created"
      end

      desc 'update', 'Update a trigger'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :trigger_id, required: true
      method_option :description, required: true, aliases: '-d'
      method_option :test, boolean: true

      def update_trigger
        begin
          response = RestClient::Request.execute(
            method: :put,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            payload: { 'description' => options[:description] },
            url: "#{options[:url]}/api/v4/projects/#{options[:id]}/triggers/#{options[:trigger_id]}",
            verify_ssl: false,
            timeout: 60
          )

          trigger = JSON.parse(response)
        rescue => e
          puts 'API error'
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end
        puts "Trigger #{trigger['id']} updated with description: #{trigger['description']}"
      end

      desc 'owner', 'Take ownership of a trigger'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :trigger_id, required: true
      method_option :test, boolean: true

      def ownership_trigger
        begin
          response = RestClient::Request.execute(
            method: :post,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            url: "#{options[:url]}/api/v4/projects/#{options[:id]}/triggers/#{options[:trigger_id]}/take_ownership",
            verify_ssl: false,
            timeout: 60
          )

          trigger = JSON.parse(response)
        rescue => e
          puts 'API error'
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end
        puts "User #{trigger['owner']['name']} took ownership of trigger #{options['trigger_id']}"
      end

      desc 'delete', 'Delete a trigger'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :trigger_id, required: true
      method_option :test, boolean: true

      def delete_trigger
        begin
          RestClient::Request.execute(
            method: :delete,
            headers: { 'PRIVATE-TOKEN' => options[:token] },
            url: "#{options[:url]}/api/v4/projects/#{options[:id]}/triggers/#{options[:trigger_id]}",
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
        puts "Trigger #{options['trigger_id']} deleted"
      end

      desc 'build', 'Build a trigger'

      method_option :id, required: true, aliases: '-i'
      method_option :token, required: true, aliases: '-t'
      method_option :url, required: true, aliases: '-u'
      method_option :trigger_token, required: true, aliases: '-t'
      method_option :branch, default: 'master', aliases: '-b'
      method_option :variables, type: :hash, aliases: '-v'
      method_option :follow, boolean: true, aliases: '-f'
      method_option :test, boolean: true

      def build_trigger
        begin
          response = if options[:variables]
                       RestClient::Request.execute(
                         method: :post,
                         headers: { 'PRIVATE-TOKEN' => options[:token] },
                         payload: { 'token' => options[:trigger_token], 'ref' => options[:branch], 'variables' => options[:variables] },
                         url: "#{options[:url]}/api/v4/projects/#{options[:id]}/trigger/pipeline",
                         verify_ssl: false,
                         timeout: 60
                       )
                     else
                       RestClient::Request.execute(
                         method: :post,
                         headers: { 'PRIVATE-TOKEN' => options[:token] },
                         payload: { 'token' => options[:trigger_token], 'ref' => options[:branch] },
                         url: "#{options[:url]}/api/v4/projects/#{options[:id]}/trigger/pipeline",
                         verify_ssl: false,
                         timeout: 60
                       )
                     end

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
    end
  end
end
