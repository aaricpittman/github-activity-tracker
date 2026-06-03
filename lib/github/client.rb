module Github
  class Client
    def initialize(client: Octokit::Client.new)
      @client = client
    end

    def fetch_events
      client.public_events
    end

    def rate_limit
      client.rate_limit
    end

    private

    attr_reader :client
  end
end
