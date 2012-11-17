FactoryGirl.define do
  
  factory :channel do
    name "channel1"
    ingestion_url "http://ingestion.url.com"
    broadcaster_id "1"
  end
end