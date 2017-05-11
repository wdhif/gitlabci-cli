require "thor"
require "rest-client"
require "json"
require "terminal-table"
require "time"

module Gitlabci
  module Controller
    class Trigger < Thor
      desc "list", "List the triggers for a project"

      method_option :id, :required => true, :aliases => "-i"
      method_option :token, :required => true, :aliases => "-t"
      method_option :url, :required => true, :aliases => "-u"
      method_option :test, :boolean => true

      def list_triggers
        begin
          response = RestClient::Request.execute(
                    :method => :get,
                    :headers => {"PRIVATE-TOKEN" => options[:token]},
                    :url => "#{options[:url]}/api/v4/projects/#{options[:id]}/triggers",
                    :verify_ssl => false,
                    :timeout => 60)

          triggers = JSON.parse(response)          
        rescue => e
          puts "API error"
          puts e
          unless options[:test]
            sleep 2
            retry
          end
        end

        table = Terminal::Table.new do |t|
          t.title = "Triggers for #{options[:id]}"
          t.headings = ["Id", "Token", "Description", "Created by", "Created at", "Last used"]
          triggers.each do |trigger|
            t.add_row([
              trigger["id"],
              trigger["token"],
              trigger["description"],
              trigger["owner"]["name"],
              trigger["created_at"],
              trigger["last_used"]
            ])
          end
        end

        puts table
      end

    end
  end
end
