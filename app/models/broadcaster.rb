class Broadcaster < ActiveRecord::Base
  attr_accessible :logo_url, :name
  has_many :channels
  
  def as_json(options={})
    { :id => id,
      :logo_url => logo_url,
      :name => name}
  end
  
end
