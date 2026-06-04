FactoryBot.define do
  factory :actor do
    blog { "https://www.johndoe.com" }
    company { "ABC Co" }
    email { "john.doe@example.com" }
    follower_count { 0 }
    following_count { 0 }
    hireable { false }
    location { "Nashville, TN" }
    login { "aaricpittman" }
    name { "John Doe" }
    profile_url { "https://github.com/johndoe" }
    provider_created_at { DateTime.now }
    sequence(:provider_id) { |n| n }
    provider_updated_at { DateTime.now }
    public_repo_count { 0 }
  end
end
