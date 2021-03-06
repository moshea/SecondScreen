FactoryGirl.define do
  
  factory :channel do
    name "channel1"
    ingestion_url "http://ingestion.url.com"
    broadcaster_id "1"
  end
  
  factory :user do
    imei "1234567"
    device_id "29304jskdlfa"
    os_version "4.0.4"
    api_level "16"
    make "Samsung"
    model "Galaxy II"
  end
  
  factory :broadcast do
    sequence :uuid do |n|
      SecureRandom.uuid
    end 
  end
  
  ##
  # this class doesn't really exist. It is there to replicate results from
  # a twitter search
  
  class TwitterStatus
    attr_accessor :text, :from_user
  end

  ##
  # this factory is for mocking out status that is returned 
  # from Twitter search result
  
  factory :twitter_status do
    sequence :text do |n|
      "status text #{n}"
    end
    sequence :from_user do |n|
      "user_#{n}"
    end
  end
end