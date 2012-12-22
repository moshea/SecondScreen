##
# TwitterLimiter will make search requests against shows every number of seconds
# the results will be cached in a local DB. A show can be requested to be searched
# as many times as we want, but a search request will only be made once every X seconds
# which is defined in properties.
# TwitterLimiter records the uuid of the broadcast, the time the last request was sent to
# the twitter search api and the time the last request for information was made.
# If last_api_request > X and last_user_request < X, make a search
# Otherwise, wait until that condition holds true. This will avoid unused searches on 
# unpopular shows. Also, storing a count on last_user_requests will be a good judge of
# how popular a show is.

module TwitterLimiter
  
  Logger = Logger.new(STDOUT)
  
  ## 
  # tweets will return a list of tweets associated with the broadcast id
  # param @broadcast_uuid [String] - unique id of the show to be searched for
  # param @rate_limit [Integer] - number of seconds to wait before making an external
  # request. defaults to 30
  # If the rate limit is hit (more than once every rate_limit seconds),
  # then we will get data direct from the local database
  
  def TwitterLimiter.tweets(broadcast_uuid, rate_limit=30)
    statuses = nil
    broadcast = Broadcast.find(broadcast_uuid)
    last_search = SearchLimiter.where("broadcast_uuid = ?", broadcast.uuid).last
    
    Logger.debug("last search for broadcast: #{broadcast.uuid} - #{last_search.inspect}")
    
    # if this is the first time searching for a show, we need to create
    # and entry in search limiter
    if last_search.nil?
      last_search = SearchLimiter.create(
                            :broadcast_uuid         => broadcast.uuid, 
                            :last_external_request  => nil,
                            :last_internal_request  => Time.now,
                            :search_request_count   => 0)
    end

    # if the last external request to a service was performed greater than
    # the waiting period ago, make another request and store the result
    # this is how we stop making external requests too often
    Logger.debug("last_external_request: #{last_search.last_external_request}")
    Logger.debug("Time.now - rate_limit: #{(Time.now - rate_limit)}")
    
    if !last_search.last_external_request.nil? && (last_search.last_external_request > (Time.now - rate_limit))
      statuses = Status.where("broadcast_uuid = ?", broadcast.uuid).last(100)
      
      # this time is recorded so we know how long ago an internal request was made
      last_search.last_internal_request = Time.now
      
    else
      Logger.debug("rate limit is over - fetch more results")
      terms = broadcast.search_terms
      Twitter.search(terms).results.collect do |status|
        Status.create(:broadcast_uuid => broadcast.uuid,
                        :text           => status.text,
                        :user           => status.from_user )
      end
      
      last_search.last_external_request = Time.now
    end
    
    last_search.search_request_count += 1
    last_search.save
    return Status.where("broadcast_uuid = ?", broadcast.uuid).last(100)
  end
  
end