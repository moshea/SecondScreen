class Broadcaster < ActiveRecord::Base
  attr_accessible :logo_url, :name
  has_many :channels
  
end
