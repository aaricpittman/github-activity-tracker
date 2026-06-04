module Github
  class Client
    def initialize(client: Octokit::Client.new)
      @client = client
    end

    def fetch_events
      client.public_events
    rescue Octokit::TooManyRequests
      raise RateLimited, "Github rate limit exceeded"
    end

    def refresh_actor_attributes(user)
      data = client.user(user.provider_id)

      user.assign_attributes(
        blog: data[:blog],
        company: data[:company],
        email: data[:email],
        follower_count: data[:followers],
        following_count: data[:following],
        hireable: data[:hireable],
        location: data[:location],
        login: data[:login],
        name: data[:name],
        profile_url: data[:html_url],
        provider_created_at: data[:created_at],
        provider_updated_at: data[:updated_at],
        public_repo_count: data[:public_repos],
      )
      user
    rescue Octokit::TooManyRequests
      raise RateLimited, "Github rate limit exceeded"
    end

    def refresh_repo_attributes(repo)
      data = client.repo(repo.provider_id)

      repo.assign_attributes(
        archived: data[:archived],
        default_branch: data[:default_branch],
        disabled: data[:disabled],
        fork_count: data[:fork_count],
        has_discussions: data[:has_discussions],
        has_downloads: data[:has_downloads],
        has_issues: data[:has_issues],
        has_pages: data[:has_pages],
        has_projects: data[:has_projects],
        has_pull_requests: data[:has_pull_requests],
        has_wiki: data[:has_wiki],
        language: data[:language],
        license: data.dig(:license, :key),
        name: data[:full_name],
        network_count: data[:network_count],
        open_issue_count: data[:open_issue_count],
        open_issues_count: data[:open_issues_count],
        provider_created_at: data[:created_at],
        provider_pushed_at: data[:pushed_at],
        provider_updated_at: data[:updated_at],
        stargazers_count: data[:stargazers_count],
        subscribers_count: data[:subscribers_count],
        topics: data[:topics],
        url: data[:url],
        watchers_count: data[:watchers_count]
      )
      repo
    rescue Octokit::TooManyRequests
      raise RateLimited, "Github rate limit exceeded"
    end

    private

    attr_reader :client
  end
end
