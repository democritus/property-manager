class InformationRequestsController < ApplicationController
  
  before_filter :set_information_requestable

  # GET /information_requests/new
  # GET /information_requests/new.xml
  def new
    @information_request = InformationRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @information_request }
    end
  end

  # POST /information_requests
  # POST /information_requests.xml
  def create
    @information_request = @information_requestable.information_requests.build(
      params[:information_request])
    
    respond_to do |format|
      if @information_request.save
        flash[:notice] = 'InformationRequest was successfully created.'
        format.html { redirect_to(polymorphic_url(@agency_imageable)) }
        format.xml  { render :xml => @information_request, :status => :created,
          :location => @information_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @information_request.errors,
          :status => :unprocessable_entity }
      end
    end
  end

  # PUT /information_requests/1
  # PUT /information_requests/1.xml


  private

  # If nested, set parent instance variable
  def set_information_requestable
    if params[:context_type]
      @information_requestable = context_object(
        :include => :information_requests )
    end
  end
end
