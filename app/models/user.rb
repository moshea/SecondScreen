class User < ActiveRecord::Base
  attr_accessible :imei
  
    # each broadcast needs a uuid for referencing
  after_initialize do
    self.uuid ||= SecureRandom.uuid
  end
  
  def as_json(options={})
    {:uuid => uuid}
  end
end
