module ApplicationHelper
  
  def attachment_url(file, style=:medium)
    "#{request.protocol}#{request.host_with_port}#{file.url(style)}"
  end
end
