class Webhooks::ProcessGithubEventJob < ApplicationJob
  queue_as :default

  def perform(id)
    return unless (@webhook = Webhooks::GithubEvent.find_by(id: id))
    return if webhook.processed?

    create_push_event
    mark_webhook_as_processed
  end

  private

  attr_reader :push_event, :webhook

  def create_push_event
    @push_event = PushEvent.find_or_create_from_github_event(webhook)
  end

  def mark_webhook_as_processed
    webhook.processed!
  end
end
