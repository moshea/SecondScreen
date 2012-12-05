class Channel < ActiveRecord::Base  
  attr_accessible :ingestion_module, :ingestion_url, :logo_url, :name, :logo
  has_attached_file :logo, :styles => {:medium => "20x20>", :large => "40x40>", :hd => "80x80>", :xhd => "120x120>"} 
  
  belongs_to :broadcaster
  
  def ingest(date)
    logger.debug ingestion_module + ".perform_async(#{id}, '#{date}')"
    eval(ingestion_module + ".perform_async(#{id}, '#{date}')")
  end
  
  def as_json(options={})
    { :id => id,
      :broadcaster_id => broadcaster_id, 
      :logoUrl => IMAGE_HOST + logo.url(:large),
      :name => name }
  end
end
