class Webhooks::GithubEvent < ApplicationRecord
  enum :status, [:received, :processed, :failed]

  validates :github_event_id, presence: true, uniqueness: true
  validates :payload, presence: true
end
