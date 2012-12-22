class SearchLimiter < ActiveRecord::Base
  attr_accessible :broadcast_uuid, :last_external_request, :last_internal_request, :search_request_count
end
