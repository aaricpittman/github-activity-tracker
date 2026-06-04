require 'rails_helper'

RSpec.describe Webhooks::ProcessGithubEventJob, type: :job do
  describe "#perform" do
    let(:subject) { Webhooks::ProcessGithubEventJob.new }

    describe "webhook record does not exist" do
      it "should do nothing" do
        expect(PushEvent).to receive(:find_or_create_from_github_event).never

        subject.perform(0)
      end
    end

    describe "webhook already marked as processed" do
      let(:webhook) { create(:webhooks_github_event, status: :processed) }

      it "should do nothing" do
        expect(PushEvent).to receive(:find_or_create_from_github_event).never

        subject.perform(0)
      end
    end

    describe "webhook record exists" do
      let(:webhook) { create(:webhooks_github_event) }

      it "should create a PushEvent record" do
        expect {
          subject.perform(webhook.id)
        }.to change { PushEvent.count }

        push_event = PushEvent.last

        expect(push_event.provider_id).to eq(webhook.github_event_id)
      end

      it "should mark the webhook record as processed" do
        expect(webhook.received?).to be true

        subject.perform(webhook.id)

        webhook.reload

        expect(webhook.received?).to be false
        expect(webhook.processed?).to be true
      end
    end
  end
end
