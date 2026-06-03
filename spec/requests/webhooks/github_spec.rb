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
        Webhooks::GithubEvent.create!(github_event_id: event[:id], payload: event)
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
    {
      id: "12785874871",
      type: "PushEvent",
      actor: {
        id: 285946692,
        login: "tfrancha",
        display_login: "tfrancha",
        gravatar_id: "",
        url: "https://api.github.com/users/tfrancha",
        avatar_url: "https://avatars.githubusercontent.com/u/285946692?"
      },
      repo: {
        id: 1253356392,
        name: "tfrancha/rdyran",
        url: "https://api.github.com/repos/tfrancha/rdyran"
      },
      payload: {
        repository_id: 1253356392,
        push_id: 35075477329,
        ref: "refs/heads/main",
        head: "1e2e72256831835f1367a6e3807e9b91bff4f3d5",
        before: "4dea728781a83e34dc89db0ca8374e03e7c77c15"
      },
      public: true,
      created_at: "2026-06-03T19:49:03.000Z"
    }.merge(kwargs)
  end
end
