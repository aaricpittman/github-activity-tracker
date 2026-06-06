args = ARGV.any? ? {num_events: ARGV[0].to_i} : {}

ActivityTracker::GithubEventIngest.run(**args)
