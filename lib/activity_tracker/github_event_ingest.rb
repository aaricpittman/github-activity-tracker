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
      logger.info "starting"

      loop do
        github.fetch_events.each do |event|
          activity_tracker.send_github_event(event)
        end
      end

      logger.info "stopping"
    rescue Octokit::TooManyRequests
      logger.info "stopping"
    end

    private

    attr_reader :activity_tracker, :github
  end
end
