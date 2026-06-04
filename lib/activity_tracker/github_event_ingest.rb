module ActivityTracker
  class GithubEventIngest
    include SemanticLogger::Loggable

    def self.run
      new.run
    end

    def initialize(activity_tracker: ActivityTracker::Client.new, github: Github::Client.new)
      @activity_tracker = activity_tracker
      @github = github
    end

    def run
      logger.info "ingest.github_events.starting"

      loop do
        github.fetch_events.each do |event|
          logger.info "ingest.github_events.sending_event", github_event_id: event.id
          activity_tracker.send_github_event(event)
        end
      end

      logger.info "ingest.github_events.stopping"
    rescue Github::RateLimited
      logger.info "ingest.github_events.rate_limited", **github.rate_limit
    end

    private

    attr_reader :activity_tracker, :github
  end
end
