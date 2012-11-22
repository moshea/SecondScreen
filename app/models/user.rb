class User < ActiveRecord::Base
  attr_accessible :imei, :device_id, :os_version, :api_level, :make, :model
  
    # each broadcast needs a uuid for referencing
  after_initialize do
    self.uuid ||= SecureRandom.uuid
  end
  
  def as_json(options={})
    {:uuid => uuid}
  end
end
