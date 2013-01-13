class Broadcast < ActiveRecord::Base
  attr_accessible :broadcaster_broadcast_id, :broadcaster_program_id, 
                  :channel_id, :end, :start, :subtitle, :synopsis, :title, :uuid,
                  :broadcast_list
                  
  attr_reader :SECONDS_BEFORE_FILTER, :SECONDS_AFTER_FILTER
  
  acts_as_taggable
  acts_as_taggable_on :broadcasts
  
  SECONDS_BEFORE_FILTER = 60*60*12
  SECONDS_AFTER_FILTER = 60*60*12
  
  ##
  # each broadcast needs a uuid for referencing
  
  after_initialize do
    self.uuid ||= SecureRandom.uuid
  end
  
  ##
  # fetch all the shows which are running today.
  # today is defined by before and after filters
  
  def self.today(channel_id=nil)
    if channel_id
    self.where(:channel_id => channel_id).
            where("start >= ? and end <= ?", 
                  Time.now - SECONDS_BEFORE_FILTER, 
                  Time.now + SECONDS_AFTER_FILTER)
    else
      self.where("start >= ? and end <= ?", 
                  Time.now - SECONDS_BEFORE_FILTER, 
                  Time.now + SECONDS_AFTER_FILTER)   
    end
  end
  
  ##
  # fetch a list of shows across all channels which are on now
  
  def self.now
    self.where("start <= ? and end >= ?", Time.now, Time.now )
  end
  
  ##
  # search_terms gathers all the search terms that can be used for
  # a show, and returns them as a search string which can be used
  # as part of a twitter search, or any other search
  
  def search_terms
    return self.broadcast_list
  end
  
  ##
  # @param terms = {:series=>"", :episode=>"", :broadcast=>""}
  def search_terms=(terms)
    self.broadcast_list = terms[:broadcast]
    self.save
  end
  
  def as_json(options={})
    {:channel_id => channel_id,
      :start => start,
      :end => self.end,
      :title => title,
      :subtitle => subtitle,
      :synopsis => synopsis,
      :uuid => uuid}
  end

end
