class PushEvent < ApplicationRecord
  validates :provider_id, presence: true, uniqueness: true
  validates :provider_repository_id, presence: true
  validates :push_id, presence: true
  validates :ref, presence: true
  validates :head, presence: true
  validates :before, presence: true

  belongs_to :actor
  belongs_to :repo
end
