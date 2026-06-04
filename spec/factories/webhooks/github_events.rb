FactoryBot.define do
  factory :webhooks_github_event, class: "Webhooks::GithubEvent" do
    transient do
      event_type { "PushEvent" }
    end

    github_event_id { "12785874871" }
    payload {
      {
        id: github_event_id,
        type: event_type,
        actor: {
          id: 285946692,
          login: "tfrancha",
          display_login: "tfrancha",
          gravatar_id: "",
          url: "https://api.github.com/users/tfrancha",
          avatar_url: "https://avatars.githubusercontent.com/u/285946692?"
        },
        repo: {
          id: 1253356392,
          name: "tfrancha/rdyran",
          url: "https://api.github.com/repos/tfrancha/rdyran"
        },
        payload: {
          repository_id: 1253356392,
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
