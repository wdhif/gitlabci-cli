require "spec_helper"

RSpec.describe Gitlabci::Controller::Cli, :type => :aruba do

  context "without arguments" do
    it "print the help" do
      expect(Gitlabci::Controller::Cli.start).not_to be nil
    end

  end

  context "with arguments" do
    it "print the help" do
      args = ["help"]
      expect(Gitlabci::Controller::Cli.start(args)).not_to be nil
    end

    it "list the pipelines" do

      response = '[
        {
          "id": 1,
          "ref": "master",
          "status": "running",
          "user": {
            "name": "Kevin Flynn"
          },
          "created_at": "2017-04-19T12:06:58.651Z",
          "finished_at": null
        },
        {
          "id": 2,
          "ref": "master",
          "status": "finished",
          "user": {
            "name": "Kevin Flynn"
          },
          "created_at": "2017-04-19T11:02:34.468Z",
          "finished_at": "2017-04-19T12:06:58.550Z"
        }
      ]'

      pipelines = JSON.parse(response)

      table = Terminal::Table.new do |t|
        t.title = "Pipelines for 1"
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

      stub_request(:get, "https://gitlab.fr/api/v3/projects/1/pipelines/").
        with(headers: {"Private-Token"=>"1234"}).
        to_return(status: 200, body: response, headers: {})

      expect do
        args = ["list","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "--test"]
        Gitlabci::Controller::Cli.start(args)
      end.to output(puts table).to_stdout

    end

    it "get a pipeline" do
      response = "{
        "status": "running"
      }"

      stub_request(:get, "https://gitlab.fr/api/v3/projects/1/pipelines/1").
         with(headers: {"Private-Token"=>"1234"}).
         to_return(status: 200, body: response, headers: {})

      expect do
        args = ["get","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "-p", 1, "--test"]
        Gitlabci::Controller::Cli.start(args)
      end.to output("running\n").to_stdout

    end

    it "run a pipelines" do
      response = "{
        "id": 1
      }"

      stub_request(:post, "https://gitlab.fr/api/v3/projects/1/pipeline?ref=master").
        with(headers: {"Private-Token"=>"1234"}).
        to_return(status: 200, body: response, headers: {})

      expect do
        args = ["run","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "--test"]
        Gitlabci::Controller::Cli.start(args)
      end.to output("Pipeline job 1 has been started\n").to_stdout

    end

    it "retry a pipeline" do
      response = "{
        "id": 1
      }"

      stub_request(:post, "https://gitlab.fr/api/v3/projects/1/pipelines/1/retry").
         with(headers: {"Private-Token"=>"1234"}).
         to_return(status: 200, body: response, headers: {})

      expect do
        args = ["retry","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "-p", 1, "--test"]
        Gitlabci::Controller::Cli.start(args)
      end.to output("Pipeline job 1 has been started\n").to_stdout

    end

    it "cancel a pipeline" do
      response = "{
        "id": 1
      }"

      stub_request(:post, "https://gitlab.fr/api/v3/projects/1/pipelines/1/cancel").
         with(headers: {"Private-Token"=>"1234"}).
         to_return(status: 200, body: response, headers: {})

      expect do
        args = ["cancel","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "-p", 1, "--test"]
        Gitlabci::Controller::Cli.start(args)
      end.to output("Pipeline job 1 has been canceled\n").to_stdout

    end

  end
end
