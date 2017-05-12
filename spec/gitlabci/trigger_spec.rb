require "spec_helper"

RSpec.describe Gitlabci::Controller::Trigger, :type => :aruba do

  context "without arguments" do
    it "print the help" do
      expect(Gitlabci::Controller::Trigger.start).not_to be nil
    end
  end

  context "with arguments" do
    it "print the help" do
      args = ["help"]
      expect(Gitlabci::Controller::Trigger.start(args)).not_to be nil
    end

    it "list the triggers" do
      response = '[
        {
          "id": 1,
          "token": "RANDOM_TOKEN",
          "description": "description",
          "created_at": "2017-05-11T14:05:06.659Z",
          "updated_at": "2017-05-11T14:05:06.659Z",
          "deleted_at": null,
          "last_used": "2017-05-11T14:14:12.871Z",
          "owner": {
            "name": "Kevin Flynn",
            "username": "Creator4983",
            "id": 1,
            "state": "active"
          }
        },
        {
          "id": 2,
          "token": "RANDOM_TOKEN",
          "description": "description",
          "created_at": "2017-05-11T14:05:06.659Z",
          "updated_at": "2017-05-11T14:05:06.659Z",
          "deleted_at": null,
          "last_used": "2017-05-11T14:14:12.871Z",
          "owner": {
            "name": "Kevin Flynn",
            "username": "Creator4983",
            "id": 1,
            "state": "active"
          }
        }
      ]'

      triggers = JSON.parse(response)

      table = Terminal::Table.new do |t|
        t.title = "Triggers for 1"
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

      stub_request(:get, "https://gitlab.fr/api/v4/projects/1/triggers")
        .with(headers: {"PRIVATE-TOKEN" => "1234"})
        .to_return(status: 200, body: response, headers: {})

      expect do
        args = ["list","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "--test"]
        Gitlabci::Controller::Trigger.start(args)
      end.to output(puts table).to_stdout
    end

    it "create a trigger" do
      response = '{
        "id": 1,
        "token": "RANDOM_TOKEN",
        "description": "description",
        "created_at": "2017-05-11T14:05:06.659Z",
        "updated_at": "2017-05-11T14:05:06.659Z",
        "deleted_at": null,
        "last_used": "2017-05-11T14:14:12.871Z",
        "owner": {
          "name": "Kevin Flynn",
          "username": "Creator4983",
          "id": 1,
          "state": "active"
        }
      }'

      stub_request(:post, "https://gitlab.fr/api/v4/projects/1/triggers")
        .with(headers: {"PRIVATE-TOKEN" => "1234"}, body: {"description" => "description"})
        .to_return(status: 200, body: response, headers: {})

      expect do
        args = ["create","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "-d", "description", "--test"]
        Gitlabci::Controller::Trigger.start(args)
      end.to output("Trigger 1 created\n").to_stdout
    end

    it "changes the owner of a trigger" do
      response = '{
        "id": 1,
        "token": "RANDOM_TOKEN",
        "description": "description",
        "created_at": "2017-05-11T14:05:06.659Z",
        "updated_at": "2017-05-11T14:05:06.659Z",
        "deleted_at": null,
        "last_used": "2017-05-11T14:14:12.871Z",
        "owner": {
          "name": "Kevin Flynn",
          "username": "Creator4983",
          "id": 1,
          "state": "active"
        }
      }'

      stub_request(:post, "https://gitlab.fr/api/v4/projects/1/triggers/1/take_ownership")
        .with(headers: {"PRIVATE-TOKEN" => "1234"})
        .to_return(status: 200, body: response, headers: {})

      expect do
        args = ["owner","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "--trigger_id", "1", "--test"]
        Gitlabci::Controller::Trigger.start(args)
      end.to output("User Kevin Flynn took ownership of trigger 1\n").to_stdout
    end

    it "update a trigger" do
      response = '{
        "id": 1,
        "token": "RANDOM_TOKEN",
        "description": "description_updated",
        "created_at": "2017-05-11T14:05:06.659Z",
        "updated_at": "2017-05-11T14:05:06.659Z",
        "deleted_at": null,
        "last_used": "2017-05-11T14:14:12.871Z",
        "owner": {
          "name": "Kevin Flynn",
          "username": "Creator4983",
          "id": 1,
          "state": "active"
        }
      }'

      stub_request(:put, "https://gitlab.fr/api/v4/projects/1/triggers/1")
        .with(headers: {"PRIVATE-TOKEN" => "1234"}, body: {"description" => "description_updated"})
        .to_return(status: 200, body: response, headers: {})

      expect do
        args = ["update","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "--trigger_id", "1", "-d", "description_updated", "--test"]
        Gitlabci::Controller::Trigger.start(args)
      end.to output("Trigger 1 updated with description: description_updated\n").to_stdout
    end

    it "delete a trigger" do
      stub_request(:delete, "https://gitlab.fr/api/v4/projects/1/triggers/1")
        .with(headers: {"PRIVATE-TOKEN" => "1234"})
        .to_return(status: 200, body: "", headers: {})

      expect do
        args = ["delete","-i", "1", "-t", "1234", "-u", "https://gitlab.fr", "--trigger_id", "1", "--test"]
        Gitlabci::Controller::Trigger.start(args)
      end.to output("Trigger 1 deleted\n").to_stdout
    end
  end
end
