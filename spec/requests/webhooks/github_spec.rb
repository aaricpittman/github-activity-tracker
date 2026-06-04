require 'rails_helper'

RSpec.describe "Webhooks::Githubs", type: :request do
  describe "POST /create" do
    describe "valid event payload" do
      let(:event) { build_event_payload }

      it "persists the event" do
        expect {
          post "/webhooks/github", params: { event: event }, as: :json
        }.to change { Webhooks::GithubEvent.count }.by(1)
      end

      it "it enques process job" do
        post "/webhooks/github", params: { event: event }, as: :json

        webhook = Webhooks::GithubEvent.last

        expect(Webhooks::ProcessGithubEventJob).to have_been_enqueued.with(webhook.id)
      end

      it "returns http success" do
        post "/webhooks/github", params: { event: event }, as: :json

        expect(response).to have_http_status(:success)
      end
    end

    describe "non-tracked event type" do
      let(:event) { build_event_payload(type: "CreateEvent") }

      it "should not persist the event" do
        expect {
          post "/webhooks/github", params: { event: event }, as: :json
        }.not_to change { Webhooks::GithubEvent.count }
      end

      it "returns http success" do
        post "/webhooks/github", params: { event: event }, as: :json

        expect(response).to have_http_status(:success)
      end
    end

    describe "already processed event id" do
      let(:event) { build_event_payload }

      before do
        Webhooks::GithubEvent.create!(github_event_id: event["id"], payload: event)
      end

      it "should not persist the event" do
        expect {
          post "/webhooks/github", params: { event: event }, as: :json
        }.not_to change { Webhooks::GithubEvent.count }
      end

      it "returns http success" do
        post "/webhooks/github", params: { event: event }, as: :json

        expect(response).to have_http_status(:success)
      end
    end
  end

  def build_event_payload(**kwargs)
    build(:webhooks_github_event).payload.merge(kwargs)
  end
end
