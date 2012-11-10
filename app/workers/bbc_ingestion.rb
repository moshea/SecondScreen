require 'logger'

class BBCIngestion
  include Sidekiq::Worker
  
  FORMAT = ".xml"
  SCHEDULE_DATE_FORMAT = "%Y-%m-%dT%H:%M:%S%z"
  logger = Logger.new(STDOUT)
  
  def perform(channel_id, date)
    @channel = Channel.find(channel_id)

    url = @channel.ingestion_url + ingestion_formatted_date(date) + FORMAT 
    logger.info url
  
    schedule = pull_schedule(url)
    
    ingest_schedule(schedule)
  end
  
  def pull_schedule(url)
    xml = Nokogiri::HTML(open(url))
  end
  
  def ingestion_formatted_date(date)
    d = Date.strptime(date, '%Y-%m-%d')
    d.strftime("/%Y/%m/%d")
  end
  
  def ingest_schedule(schedule)
    # we place
    broadcasts = []
    schedule.xpath('//broadcast').each do |broadcast|
      broadcasts << Broadcast.new do |b|
        b.channel_id = @channel.id
        b.broadcaster_broadcast_id = broadcast.xpath('pid').text
        b.start = DateTime.strptime(broadcast.xpath('start').text, SCHEDULE_DATE_FORMAT).utc
        b.end = DateTime.strptime(broadcast.xpath('end').text, SCHEDULE_DATE_FORMAT).utc
        b.broadcaster_program_id = broadcast.xpath('programme/pid').text
        b.synopsis = broadcast.xpath('programme/short_synopsis').text
        b.title = broadcast.xpath('programme/display_titles/title').text
        b.subtitle = broadcast.xpath('programme/display_titles/subtitle').text
      end
    end
    Broadcast.transaction do
      broadcasts.each{ |broadcast| broadcast.save }
    end
  end 
  
end