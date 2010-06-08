class Images::PropertyImagesController < Images::ImagesController

  caches_page :show, :thumb, :medium, :fullsize, :original, :listing_glider,
    :listing_glider_placeholder, :mini_glider, :mini_glider_placeholder,
    :mini_glider_suggested, :mini_glider_similar, :mini_glider_recent,
    :large_glider, :large_glider_placeholder, :featured
  
  # Collection of featured images containing associated listing. This is used
  # for outputting images that link to the listing page, such as the images
  # in the image glider
  # 
  # GET /property_images/featured
  def featured
    @property_images = PropertyImage.featured

    respond_to do |format|
      format.html # featured.html.erb
    end
  end

  # GET /property_images/1
  # GET /property_images/1.jpg
  def show
    @property_image = PropertyImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.jpg  # show.jpg.flexi
    end
  end
  
  # Resized images
  ################
  
  # GET /property_images/123/thumb.jpg
  def thumb
    @property_image = PropertyImage.find(params[:id])
    respond_to do |format|
      format.jpg  # thumb.jpg.flexi
    end
  end
  
  # GET /property_images/123/medium.jpg
  def medium
    @property_image = PropertyImage.find(params[:id])
    respond_to do |format|
      format.jpg  # medium.jpg.flexi
    end
  end
  
  # GET /property_images/123/original
  # GET /property_images/123/original.jpg
  def fullsize
    @property_image = PropertyImage.find(params[:id])
    respond_to do |format|
      format.html # fullsize.html.erb
      format.jpg  # fullsize.jpg.flexi
    end
  end
  
  # GET /property_images/123/original
  # GET /property_images/123/original.png
  def original
    @property_image = PropertyImage.find(params[:id])
    respond_to do |format|
      format.html # original.html.erb
      format.png  # original.png.flexi
    end
  end
  
  # GET /property_images/123/large_glider.jpg
  def large_glider
    @property_image = PropertyImage.find(params[:id])
    respond_to do |format|
      format.jpg  # large_glider.jpg.flexi
    end
  end
  
  # GET /property_images/large_glider_placeholder
  def large_glider_placeholder
    respond_to do |format|
      format.jpg  # large_glider_placeholder.jpg.flexi
    end
  end
  
  # GET /property_images/123/listing_glider.jpg
  def listing_glider
    @property_image = PropertyImage.find(params[:id])
    respond_to do |format|
      format.jpg  # listing_glider.jpg.flexi
    end
  end
  
  # GET /property_images/listing_glider_placeholder
  def listing_glider_placeholder
    respond_to do |format|
      format.jpg  # listing_glider_placeholder.jpg.flexi
    end
  end
  
  # GET /property_images/123/mini_glider.jpg
  def mini_glider
    @property_image = PropertyImage.find(params[:id])
    respond_to do |format|
      format.jpg  # mini_glider.jpg.flexi
    end
  end
  
  # GET /property_images/mini_glider_placeholder
  def mini_glider_placeholder
    respond_to do |format|
      format.jpg  # mini_glider_placeholder.jpg.flexi
    end
  end
  
  # GET /property_images/mini_glider_recent
  def mini_glider_recent
    respond_to do |format|
      format.jpg  # mini_glider_recent.jpg.flexi
    end
  end
  
  # GET /property_images/mini_glider_suggested
  def mini_glider_suggested
    respond_to do |format|
      format.jpg  # mini_glider_suggested.jpg.flexi
    end
  end
  
  # GET /property_images/mini_glider_similar
  def mini_glider_similar
    respond_to do |format|
      format.jpg  # mini_glider_similar.jpg.flexi
    end
  end
end
