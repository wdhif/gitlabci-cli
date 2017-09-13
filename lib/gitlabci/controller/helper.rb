require 'json'
require 'rest-client'

module Gitlabci
  module Controller
    # Helper Module
    module Helper
      module_function

      def get_job_status(id = nil, url = nil, token = nil, pipeline = nil, test = false)
        begin
          response = RestClient::Request.execute(
            method: :get,
            headers: { 'PRIVATE-TOKEN' => token },
            url: "#{url}/api/v4/projects/#{id}/pipelines/#{pipeline}/jobs",
            verify_ssl: false,
            timeout: 60
          )
          jobs = JSON.parse(response)
        rescue => e
          puts 'API error'
          puts e
          unless test
            sleep 2
            retry
          end
        end
        helper_response = {}
        jobs.each do |job|
          helper_response[job['name']] = job['status']
        end
        helper_response
      end

      def follow(options, pipeline)
        puts "\e[32mWaiting for pipeline #{pipeline['id']} to finish\e[0m"
        jobs = Gitlabci::Controller::Helper.get_job_status(options['id'], options['url'], options['token'], pipeline['id'], false)
        puts "\e[32m#{jobs.length} jobs in pipeline\e[0m"
        jobs.each_key do |k|
          puts "\e[32mJob #{k}\e[0m"
        end
        time = 0
        loop do
          puts 'The api is not responding, wait for next call' if jobs.nil?

          jobs = Gitlabci::Controller::Helper.get_job_status(options['id'], options['url'], options['token'], pipeline['id'], false)
          sleep 2
          if (time % 10).zero?
            puts "\e[32mStarted since #{time} seconds\e[0m" if time != 0
            jobs.each do |k, v|
              puts "#{k} status is #{v}"
            end
          end
          time += 2
          break if !jobs.values.include?('created') && !jobs.values.include?('running') && !jobs.values.include?('pending') && !jobs.nil?
        end

        if jobs.values.uniq == ['success']
          puts "\e[32mPipeline passed\e[0m"
          jobs.each do |k, v|
            puts "\e[32m#{k} status is #{v}\e[0m"
          end
          exit 0
        else
          puts "\e[31mPipeline #{pipeline['id']} failed\e[0m"
          jobs.each do |k, v|
            puts "\e[31m#{k} status is #{v}\e[0m"
          end
        end
        exit 1
      end
    end
  end
end
