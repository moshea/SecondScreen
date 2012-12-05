class ImagesController < ApplicationController
  
  # /images/[:id]/resize
  def resize
    # remove any characters that would allow a change in directory
    image_name = params[:id].gsub(/\//, '')
    original_image = Magick::Image.read(APP_LIB_DIR + APP_LIB_DIR_IMAGES + "/" + params[:id])
    
    resized_image = original_image.resize_to_fit(200, 200)
    @response.headers["Content-type"] = resized_image.mime_type
    render :text => resized_image.to_blob
  end
end
