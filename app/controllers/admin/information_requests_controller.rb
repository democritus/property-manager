class Admin::InformationRequestsController < Admin::AdminController

  before_filter :set_information_requestable
    
  # GET /information_requests
  # GET /information_requests.xml
  def index
    @information_requests = @information_requestable.information_requests

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /information_requests/1
  # GET /information_requests/1.xml
  def show
    @information_request = InformationRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /information_requests/1/edit
  def edit
    @information_request = InformationRequest.find(params[:id])
  end

  # PUT /information_requests/1
  # PUT /information_requests/1.xml
  def update
    @information_request = InformationRequest.find(params[:id])

    respond_to do |format|
      if @information_request.update_attributes(params[:information_request])
        flash[:notice] = 'InformationRequest was successfully updated.'
        format.html { redirect_to(polymorphic_url(:admin,
          [@information_requestable, @information_request])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /information_requests/1
  # DELETE /information_requests/1.xml
  def destroy
    @information_request = InformationRequest.find(params[:id])
    @information_request.destroy

    respond_to do |format|
      format.html { redirect_to(polymorphic_url(:admin,
        [@information_requestable, :information_requests])) }
    end
  end


  private

  # If nested, set parent instance variable
  def set_information_requestable
    if params[:context_type]
      @information_requestable = context_object( :include => :information_requests )
    end
  end
end
