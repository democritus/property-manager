class CountriesController < ApplicationController

  # TODO: re-enable this to test caching
  #caches_page :show
  
  # GET /countries/1
  # GET /countries/1.xml
  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country }
    end
  end
end
