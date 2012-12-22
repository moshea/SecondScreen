require '../test_helper'

class TwitterLimiterTest < ActiveSupport::TestCase
  def setup
    @broadcast = FactoryGirl.build(:broadcast)
    Broadcast.stubs(:find).returns(@broadcast)
    @search_results = []
    @twitter_status = (0..1).collect{ FactoryGirl.build(:twitter_status) }
    Twitter.stubs(:search).returns(@search_results)
    @search_results.stubs(:results).returns(@twitter_status)
  end
  
  test "limiter should return twitter results if its the first request for that broadcast" do
    tweets = TwitterLimiter.tweets(@broadcast.uuid)
    puts tweets.inspect
    assert tweets[0].text == @twitter_status[0].text
  end
  
  test "limiter should return database results if two requests are made within the rate limiting time" do
    TwitterLimiter.tweets(@broadcast.uuid)
    # this will force twitter to return another set of results if called
    @second_twitter_status = (0..1).collect{ FactoryGirl.build(:twitter_status) }
    @search_results.stubs(:results).returns(@second_twitter_status)
    assert TwitterLimiter.tweets(@broadcast.uuid).count == 2
  end
  
  test "limiter should make external call if the rate limiting time has passed" do
    TwitterLimiter.tweets(@broadcast.uuid, 30)
    
    @second_twitter_status = (0..1).collect{ FactoryGirl.build(:twitter_status) }
    @search_results.stubs(:results).returns(@second_twitter_status)
    @time_now = Time.now + 40
    Time.stubs(:now).returns(@time_now)
    
    tweets = TwitterLimiter.tweets(@broadcast.uuid, 30)
    assert tweets.count == 4 , "TwitterLimiter returned #{tweets.length}, should be 4"
  end
end