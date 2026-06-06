module ActivityTracker
  class GithubEventIngest
    include SemanticLogger::Loggable

    def self.run(...)
      new.run(...)
    end

    def initialize(activity_tracker: ActivityTracker::Client.new, github: Github::Client.new)
      @activity_tracker = activity_tracker
      @github = github
    end

    def run(num_events: calculate_page_size)
      logger.info "ingest.github_events.starting"

      logger.info "ingest.github_events.fetching_events", num_of_events: num_events
      github.fetch_events(per_page: num_events).each do |event|
        logger.info "ingest.github_events.sending_event", github_event_id: event.id
        case (response = activity_tracker.send_github_event(event)).code
        when 200...300 then next
        else
          logger.error "ingest.github_events.send_failed", event: event.to_h, response_code: response.code
        end
      end

      logger.info "ingest.github_events.stopping"
    rescue Github::RateLimited
      logger.info "ingest.github_events.rate_limited", **github.rate_limit.to_h
    end

    private

    attr_reader :activity_tracker, :github

    # calculate the number of events that can be processed during the current window.
    # 1 request to fetch the events and at most 2 requests per event to fetch actor and
    # repository data. could be less if data is already cached in the database and fresh
    def calculate_page_size
      (github.rate_limit.limit - 1) / 2
    end
  end
end
