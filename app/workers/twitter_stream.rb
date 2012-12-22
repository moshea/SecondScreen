##
# twitter stream is used to track multiple users at once
# code is parked until the ability for users to log in via twitter is created
class TwitterStream
  include Sidekiq::Worker
  
  def perform
    
    TweetStream.configure do |config|
      config.consumer_key       = CONFIG[:twitter][:consumer_key]
      config.consumer_secret    = CONFIG[:twitter][:consumer_secret]
      config.oauth_token        = CONFIG[:twitter][:oauth_token]
      config.oauth_token_secret = CONFIG[:twitter][:oauth_token_secret]
      config.auth_method        = :oauth
    end
    
    client = TweetStream::Client.new
    
    client.sitestream do |status|
      puts status.inspect
    end
  end
end