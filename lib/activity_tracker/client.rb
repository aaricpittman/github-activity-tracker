require "http"

module ActivityTracker
  class Client
    BASE_URL = ENV.fetch("ACTIVITY_TRACKER_BASE_URL", "http://app/")

    def initialize(http_client: HTTP.base_uri(BASE_URL))
      @http_client = http_client
    end

    def send_github_event(event)
      http_client.post("webhooks/github", json: { event: event.to_h })
    end

    private

    attr_reader :http_client
  end
end
