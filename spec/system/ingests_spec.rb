require 'rails_helper'

RSpec.describe "Ingests", :vcr, type: :system, active_job_adapter: :inline do
  it "should import" do
    visit '/'

    expect(page).to have_content "Push Events"
    expect(page).to have_css("#push-events li", count: 0)

    expect(Webhooks::GithubEvent.count).to eq(0)
    expect(PushEvent.count).to eq(0)
    expect(Actor.count).to eq(0)
    expect(Repo.count).to eq(0)

    perform_enqueued_jobs do
      ActivityTracker::GithubEventIngest.run(num_events: 1)
    end

    expect(Webhooks::GithubEvent.count).to eq(1)
    expect(Webhooks::GithubEvent.last).to be_processed
    expect(PushEvent.count).to eq(1)
    expect(Actor.count).to eq(1)
    expect(Repo.count).to eq(1)

    visit "/"

    expect(page).to have_content "Push Events"
    expect(page).to have_css("#push-events li", count: 1)
  end
end
