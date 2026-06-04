FactoryBot.define do
  factory :repo do
    archived { false }
    default_branch { "main" }
    disabled { false }
    fork_count { 0 }
    has_discussions { false }
    has_downloads { false }
    has_issues { false }
    has_pages { false }
    has_projects { false }
    has_pull_requests { false }
    has_wiki { false }
    language { "Ruby" }
    license { "mit" }
    name { "aaricpittman/dotfiles" }
    network_count { 0 }
    open_issue_count { 0 }
    open_issues_count { 0 }
    provider_created_at { Time.now }
    sequence(:provider_id) { |n| n }
    provider_pushed_at { Time.now }
    provider_updated_at { Time.now }
    stargazers_count { 0 }
    subscribers_count { 0 }
    topics { [] }
    url { "https://github.com/aaricpittman/dotfiles" }
    watchers_count { 0 }
  end
end
