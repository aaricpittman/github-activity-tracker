require 'rails_helper'

RSpec.describe PushEvent, type: :model do
  describe ".find_or_create_from_github_event" do
    let(:webhook) { create(:webhooks_github_event) }

    it "should create a PushEvent based on webhook data" do
      result = PushEvent.find_or_create_from_github_event(webhook)

      expect(result.provider_id).to eq(webhook.github_event_id)
      expect(result.repository_id).to eq(webhook.payload["payload"]["repository_id"])
      expect(result.push_id).to eq(webhook.payload["payload"]["push_id"])
      expect(result.ref).to eq(webhook.payload["payload"]["ref"])
      expect(result.head).to eq(webhook.payload["payload"]["head"])
      expect(result.before).to eq(webhook.payload["payload"]["before"])
    end
  end
end
