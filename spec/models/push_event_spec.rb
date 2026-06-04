require 'rails_helper'

RSpec.describe PushEvent, type: :model do
  describe ".create_or_find_by_github_event" do
    let(:webhook) { create(:webhooks_github_event) }
    let(:actor) { create(:actor, provider_id: webhook.actor_id) }
    let(:repo) { create(:repo, provider_id: webhook.repo_id) }

    it "should create a PushEvent based on webhook data" do
      result = PushEvent.create_or_find_by_github_event(
        provider_id: webhook.github_event_id,
        actor_id: actor.id,
        repo_id: repo.id,
        event_payload: webhook.payload
      )

      expect(result.provider_id).to eq(webhook.github_event_id)
      expect(result.repository_id).to eq(webhook.payload["payload"]["repository_id"])
      expect(result.push_id).to eq(webhook.payload["payload"]["push_id"])
      expect(result.ref).to eq(webhook.payload["payload"]["ref"])
      expect(result.head).to eq(webhook.payload["payload"]["head"])
      expect(result.before).to eq(webhook.payload["payload"]["before"])
    end
  end
end
