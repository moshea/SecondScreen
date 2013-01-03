class Status < ActiveRecord::Base
  attr_accessible :broadcast_uuid, :text, :user
  
  ##
  # latest will make an internal request to TwitterSearch
  # TwitterSearch limits how many times we make an external call to
  # twitter. So results may come direct from twitter, or they might come
  # from the local DB
  
  def self.latest(broadcast_uuid)
    statuses = TwitterLimiter.tweets(broadcast_uuid)
    return statuses
  end
end
