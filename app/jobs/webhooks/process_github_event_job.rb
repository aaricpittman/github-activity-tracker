class Webhooks::ProcessGithubEventJob < ApplicationJob
  queue_as :default

  retry_on Github::RateLimited, wait: :polynomially_longer, attempts: 5

  def initialize(*args, github_client: Github::Client.new)
    super(*args)

    @github_client = github_client
  end

  def perform(id)
    return unless (@webhook = Webhooks::GithubEvent.find_by(id: id))
    return if webhook.processed?

    process_actor
    process_repo
    create_push_event
    mark_webhook_as_processed
  end

  private

  attr_reader :actor, :push_event, :repo, :webhook, :github_client

  def create_push_event
    @push_event = PushEvent.create_or_find_by_github_event(
      provider_id: webhook.github_event_id,
      actor_id: actor.id,
      repo_id: repo.id,
      event_payload: webhook.payload
    )
  end

  def mark_webhook_as_processed
    webhook.processed!
  end

  def process_actor
    @actor = Actor.create_or_find_by(provider_id: webhook.actor_id)

    if @actor.created_at == @actor.updated_at || @actor.stale?
      @actor = github_client.refresh_actor_attributes(@actor)
      @actor.save
    end
  end

  def process_repo
    @repo = Repo.create_or_find_by(provider_id: webhook.repo_id)

    if @repo.created_at == @repo.updated_at || @repo.stale?
      @repo = github_client.refresh_repo_attributes(@repo)
      @repo.save
    end
  end
end
