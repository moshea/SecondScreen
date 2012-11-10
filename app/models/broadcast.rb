class Broadcast < ActiveRecord::Base
  attr_accessible :broadcaster_broadcast_id, :broadcaster_program_id, :channel_id, :end, :start, :subtitle, :synopsis, :title, :uuid
  
  # each broadcast needs a uuid for referencing
  after_initialize do
    self.uuid ||= SecureRandom.uuid
  end

end
