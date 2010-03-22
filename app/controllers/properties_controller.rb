class PropertiesController < ApplicationController
  
  caches_page :default_thumb, :default_medium
  
  # GET /properties/default_thumb
  def default_thumb
    respond_to do |format|
      format.jpg  # default_thumb.jpg.flexi
    end
  end
  
  # GET /properties/default_medium
  def default_medium
    respond_to do |format|
      format.jpg  # default_medium.jpg.flexi
    end
  end
end
