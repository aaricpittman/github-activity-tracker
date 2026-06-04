class Webhooks::GithubEvent < ApplicationRecord
  enum :status, [:received, :processed, :failed]

  validates :github_event_id, presence: true, uniqueness: true
  validates :payload, presence: true

  def actor_id
    payload.dig("actor", "id")
  end

  def repo_id
    payload.dig("repo", "id")
  end
end
