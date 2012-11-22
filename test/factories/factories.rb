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
end