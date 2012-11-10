class Channel < ActiveRecord::Base
  attr_accessible :ingestion_module, :ingestion_url, :logo_url, :name
  
  belongs_to :broadcaster
  
  def ingest(date)
    logger.debug ingestion_module + ".perform_async(#{id}, '#{date}')"
    eval(ingestion_module + ".perform_async(#{id}, '#{date}')")
  end
end
