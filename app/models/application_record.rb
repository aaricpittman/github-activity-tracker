class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  DATA_FRESHNESS_DURATION = 1.week

  def stale?
    updated_at.before?(DATA_FRESHNESS_DURATION.ago)
  end
end
