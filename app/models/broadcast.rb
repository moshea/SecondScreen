class Broadcast < ActiveRecord::Base
  attr_accessible :broadcaster_broadcast_id, :broadcaster_program_id, :channel_id, :end, :start, :subtitle, :synopsis, :title, :uuid
  
  # each broadcast needs a uuid for referencing
  after_initialize do
    self.uuid ||= SecureRandom.uuid
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
