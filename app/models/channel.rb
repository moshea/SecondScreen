class Channel < ActiveRecord::Base
  attr_accessible :ingestion_module, :ingestion_url, :logo_url, :name
  
  belongs_to :broadcaster
  
  def ingest(date)
    logger.debug ingestion_module + ".perform_async(#{id}, '#{date}')"
    eval(ingestion_module + ".perform_async(#{id}, '#{date}')")
  end
  
  def as_json(options={})
    { :id => id,
      :broadcaster_id => broadcaster_id, 
      :logo_url => logo_url,
      :name => name}
  end
end
