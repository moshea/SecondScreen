require 'logger'

##
# BBCIngestion can handle ingestion from all the BBC channels
# The schedule is requested over xml, and parsed into shows.
# The ingestor works from midnight to midnight, ignoring any extra
# timing that is given
# need to exectute : bundle exec sidekiq
# before running the ingestion process
# A typical broadcast comes in the format:
#
# <broadcast is_repeat="0" is_blanked="0">
#   <pid>p010kmt7</pid>
#   <start>2012-11-11T02:30:00Z</start>
#   <end>2012-11-11T02:35:00Z</end>
#   <duration>300</duration>
#   <programme type="episode">
#     <pid>b01nr17k</pid>
#     <position/>
#     <title>11/11/2012</title>
#     <short_synopsis>Detailed weather forecast.</short_synopsis>
#     <media_type>audio_video</media_type>
#     <duration>300</duration>
#     <display_titles>
#       <title>Weatherview</title>
#       <subtitle>11/11/2012</subtitle>
#     </display_titles>
#     <first_broadcast_date>2012-11-11T02:30:00Z</first_broadcast_date>
#     <ownership>
#       <service type="" id="bbc_webonly" key="">
#         <title>BBC</title>
#       </service>
#     </ownership>
#     <programme type="brand">
#       <pid>b007yy70</pid>
#       <title>Weatherview</title>
#       <position/>
#       <expected_child_count/>
#       <first_broadcast_date>2007-09-02T01:50:00+01:00</first_broadcast_date>
#       <ownership>
#         <service type="" id="bbc_webonly" key="">
#          <title>BBC</title>
#        </service>
#       </ownership>
#     </programme>
#   <is_available_mediaset_pc_sd>0</is_available_mediaset_pc_sd>
#   <is_legacy_media>0</is_legacy_media>
#   </programme>
# </broadcast>

class BBCIngestion
  include Sidekiq::Worker
  
  FORMAT = ".xml"
  SCHEDULE_DATE_FORMAT = "%Y-%m-%dT%H:%M:%S%z"
  ONE_DAY = 1
  logger = Logger.new(STDOUT)
  
  ##
  # perform is a method that is overwritten from Sidekiq::Worker
  # this method is called to kick off the process in the different thread
  # which is useful, so we can let the user do other things.
  def perform(channel_id, date)
    @channel = Channel.find(channel_id)
    logger.info @channel.class
    
    @date = DateTime.strptime(date, '%Y-%m-%d')

    url = @channel.ingestion_url + ingestion_formatted_date(@date) + FORMAT 
    logger.info url
  
    @schedule = pull_schedule(url)
    
    ingest_schedule
  end
  
  def pull_schedule(url)
    xml = Nokogiri::HTML(open(url))
  end
  
  def ingestion_formatted_date(date)
    date.strftime("/%Y/%m/%d")
  end
  
  def ingest_schedule
    # we place
    broadcasts = []
    @schedule.xpath('//broadcast').each do |broadcast|
      broadcasts << Broadcast.new do |b|
        # each time we look at a broadcast, make sure it is starting in
        # the same day that we requested. BBC returns data until 6am the next
        # morning
        b.start = DateTime.strptime(broadcast.xpath('start').text, SCHEDULE_DATE_FORMAT).utc
        b.end = DateTime.strptime(broadcast.xpath('end').text, SCHEDULE_DATE_FORMAT).utc
        
        # only allow start times that start on the requested date
        next if b.start < @date
        break if b.start > @date + ONE_DAY 
        
        # a typical broadcast xml node is in comments at the bottom of the file
        b.channel_id = @channel.id
        b.broadcaster_broadcast_id = broadcast.xpath('pid').text
        b.broadcaster_program_id = broadcast.xpath('programme/pid').text
        b.synopsis = broadcast.xpath('programme/short_synopsis').text
        b.title = broadcast.xpath('programme/display_titles/title').text
        b.subtitle = broadcast.xpath('programme/display_titles/subtitle').text
      end
    end
    # remove the nil broadcast, as calling break or next in the middle of a loop
    # will place a nil in the array.
    broadcasts.compact!
    # commit all the broadcasts in one go
    Broadcast.transaction do
      broadcasts.each{ |broadcast| broadcast.save }
    end
  end 
  
end