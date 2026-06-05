require 'rails_helper'

RSpec.describe Webhooks::ProcessGithubEventJob, type: :job do
  describe "#perform" do
    let(:github_client) { spy("Github::Client") }
    let(:subject) { Webhooks::ProcessGithubEventJob.new(github_client: github_client) }
    let(:webhook) { create(:webhooks_github_event) }

    before do
      allow(github_client).to receive(:map_event_data_to_push_event_attributes)
        .and_return(
          {
            payload: webhook.payload,
            pushed_at: webhook.payload["created_at"],
            provider_repository_id: webhook.payload["payload"]["repository_id"],
            **webhook.payload["payload"].except("repository_id")
          }
        )
    end

    describe "webhook record does not exist" do
      it "should do nothing" do
        expect(PushEvent).to receive(:create_or_find_by).never

        subject.perform(0)
      end
    end

    describe "webhook already marked as processed" do
      let(:webhook) { create(:webhooks_github_event, status: :processed) }

      it "should do nothing" do
        expect(PushEvent).to receive(:create_or_find_by).never

        subject.perform(0)
      end
    end

    describe "webhook record exists" do
      let(:webhook) { create(:webhooks_github_event) }

      describe "actor does not exist" do
        it "should create the actor" do
          expect(github_client).to receive(:refresh_actor_attributes)

          expect {
            subject.perform(webhook.id)
          }.to change { Actor.count }
        end
      end

      describe "actor exists but is stale" do
        let!(:existing_actor) do
          Actor.create(
            provider_id: webhook.actor_id,
            updated_at: (ApplicationRecord::DATA_FRESHNESS_DURATION + 1.week).ago
          )
        end

        it "should update the actor" do
          expect(github_client).to receive(:refresh_actor_attributes)
          expect {
            subject.perform(webhook.id)
          }.not_to change { Actor.count }
        end
      end

      describe "actor exists but is not stale" do
        let!(:existing_actor) { Actor.create(provider_id: webhook.actor_id, created_at: 1.day.ago) }

        it "should do nothing to the actor" do
          expect(github_client).not_to receive(:refresh_actor_attributes)
          expect {
            subject.perform(webhook.id)
          }.not_to change { Actor.count }
        end
      end

      describe "repo does not exist" do
        it "should create the repo" do
          expect(github_client).to receive(:refresh_repo_attributes)
          expect {
            subject.perform(webhook.id)
          }.to change { Repo.count }
        end
      end

      describe "repo exists but is stale" do
        let!(:existing_repo) do
          Repo.create(
            provider_id: webhook.repo_id,
            updated_at: (ApplicationRecord::DATA_FRESHNESS_DURATION + 1.week).ago
          )
        end

        it "should update the repo" do
          expect(github_client).to receive(:refresh_repo_attributes)
          expect {
            subject.perform(webhook.id)
          }.not_to change { Repo.count }
        end
      end

      describe "repo exists but is not stale" do
        let!(:existing_repo) { Repo.create(provider_id: webhook.repo_id, created_at: 1.day.ago) }

        it "should do nothing to the repo" do
          expect(github_client).not_to receive(:refresh_repo_attributes)
          expect {
            subject.perform(webhook.id)
          }.not_to change { Repo.count }
        end
      end

      it "should create a PushEvent record" do
        actor = create(:actor, provider_id: webhook.actor_id)
        expect(github_client).to receive(:refresh_actor_attributes).and_return(actor)
        repo = create(:repo, provider_id: webhook.repo_id)
        expect(github_client).to receive(:refresh_repo_attributes).and_return(repo)

        expect {
          subject.perform(webhook.id)
        }.to change { PushEvent.count }

        push_event = PushEvent.last

        expect(push_event.provider_id).to eq(webhook.github_event_id)
        expect(push_event.actor_id).to eq(actor.id)
        expect(push_event.repo_id).to eq(repo.id)
      end

      it "should mark the webhook record as processed" do
        expect(webhook.received?).to be true
        actor = create(:actor, provider_id: webhook.actor_id)
        expect(github_client).to receive(:refresh_actor_attributes).and_return(actor)
        repo = create(:repo, provider_id: webhook.repo_id)
        expect(github_client).to receive(:refresh_repo_attributes).and_return(repo)

        subject.perform(webhook.id)

        webhook.reload

        expect(webhook.received?).to be false
        expect(webhook.processed?).to be true
      end
    end
  end
end
