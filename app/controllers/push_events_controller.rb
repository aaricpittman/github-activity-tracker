class PushEventsController < ApplicationController
  def index
  end

  private

  def push_events
    @push_events ||= PushEvent
      .includes(:actor, :repo)
      .order(pushed_at: :desc)
      # .limit(10)
  end
  helper_method :push_events
end
