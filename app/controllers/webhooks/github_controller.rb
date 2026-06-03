class Webhooks::GithubController < ApplicationController
  TRACKED_EVENT_TYPES = %w[PushEvent]

  skip_forgery_protection

  before_action :check_event_type

  def create
    record = Webhooks::GithubEvent.create!(github_event_id: event_params[:id], payload: event_params)
    # queue processing job

    head :ok
  rescue ActiveRecord::RecordInvalid => e
    if e.record.errors[:github_event_id].join.include?("taken")
      head :ok
    else
      raise
    end
  end

  private

  def check_event_type
    return if event_params[:type].in?(TRACKED_EVENT_TYPES)

    logger.warn "received untracked event type", type: event_params[:type]

    head :ok
  end

  def event_params
    params.expect(event: {})
  end
end
