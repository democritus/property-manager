class Images::UserIconsController < Images::ImagesController
  
  caches_page :show, :small

  # GET /user_icons/1
  # GET /user_icons/1.xml
  # GET /user_images/1.png
  def show
    @user_icon = UserIcon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_icon }
      format.png  # show.png.flexi
    end
  end
  
  # Resized images
  ################
  
  # GET /property_images/123/small.jpg
  def small
    @user_icon = UserIcon.find(params[:id])
    respond_to do |format|
      format.jpg  # thumb.jpg.flexi
    end
  end
end
