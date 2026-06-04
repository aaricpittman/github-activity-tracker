class PushEvent < ApplicationRecord
  validates :provider_id, presence: true, uniqueness: true
  validates :repository_id, presence: true
  validates :push_id, presence: true
  validates :ref, presence: true
  validates :head, presence: true
  validates :before, presence: true

  def self.find_or_create_from_github_event(webhook)
    create_with(payload: webhook.payload, **webhook.payload["payload"])
      .find_or_create_by!(provider_id: webhook.github_event_id)
  rescue
    find_by(provider_id: webhook.github_event_id)
  end
end
