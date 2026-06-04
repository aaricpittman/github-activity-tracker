module Github
  extend ActiveSupport::Autoload

  autoload :Client

  class RateLimited < StandardError; end
end
