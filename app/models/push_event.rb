class PushEvent < ApplicationRecord
  validates :provider_id, presence: true, uniqueness: true
  validates :repository_id, presence: true
  validates :push_id, presence: true
  validates :ref, presence: true
  validates :head, presence: true
  validates :before, presence: true

  belongs_to :actor
  belongs_to :repo

  def self.create_or_find_by_github_event(provider_id:, actor_id:, repo_id:, event_payload:)
    create_or_find_by(provider_id: provider_id) do |push_event|
      push_event.assign_attributes(
        actor_id: actor_id,
        repo_id: repo_id,
        payload: event_payload,
        **event_payload["payload"]
      )
    end
  end
end
