class PropertyImagesController < ApplicationController

  caches_page :featured, :fullsize, :original, :show
  
  def featured
    @property_image = PropertyImage.find(params[:id])
  end
  
  def fullsize
    @property_image = PropertyImage.find(params[:id])
  end
  
  def original
    @property_image = PropertyImage.find(params[:id])
  end
  
  def show
    @property_image = PropertyImage.find(params[:id])
  end
end
