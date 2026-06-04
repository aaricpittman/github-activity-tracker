require 'rails_helper'

RSpec.describe Github::Client do
  let(:octokit_double) { instance_double("Octokit::Client") }
  let(:subject) { Github::Client.new(client: octokit_double) }

  describe "#refresh_actor_attributes" do
    let(:actor) { create(:actor, name: "John Doe", login: "johndoe") }

    before do
      allow(octokit_double).to receive(:user)
        .with(actor.provider_id)
        .and_return({
          name: "Jack Sparrow",
          login: "captainsparrow"
        })
    end

    it "should update the attributes on the actor" do
      expect(actor.name).to eq("John Doe")
      expect(actor.login).to eq("johndoe")

      result = subject.refresh_actor_attributes(actor)

      expect(result.name).to eq("Jack Sparrow")
      expect(result.login).to eq("captainsparrow")
    end
  end

  describe "#refresh_repo_attributes" do
    let(:repo) { create(:repo, name: "captainsparrow/black_pearl", default_branch: "main", fork_count: 0) }

    before do
      allow(octokit_double).to receive(:repo)
        .with(repo.provider_id)
        .and_return({
          full_name: "captainsparrow/tortuga",
          default_branch: "development",
          fork_count: 1
        })
    end

    it "should update the attributes on the repo" do
      expect(repo.name).to eq("captainsparrow/black_pearl")
      expect(repo.default_branch).to eq("main")
      expect(repo.fork_count).to eq(0)

      result = subject.refresh_repo_attributes(repo)

      expect(result.name).to eq("captainsparrow/tortuga")
      expect(result.default_branch).to eq("development")
      expect(result.fork_count).to eq(1)
    end
  end
end
