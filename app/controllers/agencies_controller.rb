class AgenciesController < ApplicationController

  caches_page :show, :contact, :links, :default_logo
  
  # GET /agencies/1
  # GET /agencies/1.xml
  def show
    infer_agency
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @agency }
    end
  end

  # GET /agencies/1/contact
  # GET /agencies/1/contact.xml
  def contact
    infer_agency
    
    # User might send information request
    @information_request = InformationRequest.new

    respond_to do |format|
      format.html # contact.html.erb
      format.xml  { render :xml => @agency }
    end
  end

  # GET /agencies/1/links
  # GET /agencies/1/links.xml
  def links
    infer_agency

    respond_to do |format|
      format.html # links.html.erb
      format.xml  { render :xml => @agency }
    end
  end

  # Request information about a property
  def request_info
    # Validate data
    if params[:name].blank?
      flash[:error] = 'Name is required.'
    end
    if params[:email].blank? && params[:phone].blank?
      flash[:error] = 'Either an email address or phone number is required.'
    end
    # Send email to broker
  end
  
  # GET /agencies/1/default_logo
  def default_logo
    infer_agency
    respond_to do |format|
      format.png  # default.png.flexi
    end
  end
  
  
  private
  
  def infer_agency
    if params[:id]
      @agency = Agency.find(params[:id])
    else
      @agency = active_agency
    end
  end
end

