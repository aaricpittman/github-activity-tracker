FactoryBot.define do
  factory :webhooks_github_event, class: "Webhooks::GithubEvent" do
    transient do
      actor_id { 285946692 }
      actor_login { "johndoe" }
      event_type { "PushEvent" }
      repo_id { 1253356392 }
      repo_name { "#{actor_login}/example" }
    end

    github_event_id { "12785874871" }
    payload {
      {
        id: github_event_id,
        type: event_type,
        actor: {
          id: actor_id,
          login: actor_login,
          display_login: actor_login,
          gravatar_id: "",
          url: "https://api.github.com/users/#{actor_login}",
          avatar_url: "https://avatars.githubusercontent.com/u/#{actor_id}?"
        },
        repo: {
          id: repo_id,
          name: repo_name,
          url: "https://api.github.com/repos/#{repo_name}"
        },
        payload: {
          repository_id: repo_id,
          push_id: 35075477329,
          ref: "refs/heads/main",
          head: "1e2e72256831835f1367a6e3807e9b91bff4f3d5",
          before: "4dea728781a83e34dc89db0ca8374e03e7c77c15"
        },
        public: true,
        created_at: "2026-06-03T19:49:03.000Z"
      }
    }
  end
end
