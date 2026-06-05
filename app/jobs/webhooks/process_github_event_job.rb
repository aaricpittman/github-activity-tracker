class Webhooks::ProcessGithubEventJob < ApplicationJob
  include SemanticLogger::Loggable

  queue_as :default

  retry_on Github::RateLimited, wait: :polynomially_longer, attempts: 5

  def initialize(*args, github_client: Github::Client.new)
    super(*args)

    @github_client = github_client
  end

  def perform(id)
    unless (@webhook = Webhooks::GithubEvent.find_by(id: id))
      logger.warn "webhooks.github_events.not_found", webhook_id: id
      return
    end


    if webhook.processed?
      logger.warn "webhooks.github_events.already_processed", webhook_id: id, github_event_id: webhook.github_event_id
      return
    end

    logger.info "webhooks.github_events.processing", webhook_id: id, github_event_id: webhook.github_event_id

    process_actor
    process_repo
    create_push_event
    mark_webhook_as_processed

    logger.info "webhooks.github_events.processed", webhook_id: id, github_event_id: webhook.github_event_id
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

      if @actor.provider_avatar_url_previously_changed?
        @actor.avatar.attach(io: URI.open(@actor.provider_avatar_url), filename: "#{@actor.login}-avatar.jpg")
      end
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
