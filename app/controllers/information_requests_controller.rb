class InformationRequestsController < ApplicationController
  
  before_filter :set_information_requestable

#  def new
#    @information_request = InformationRequest.new
#  end

  def create
    @information_request = @information_requestable.information_requests.build(
    params[:information_request])
  
    if @information_request.save
      flash[:notice] = 'InformationRequest was successfully created.'
    else
      # Save data in session since we're going to redirect
      session[:information_request] = @information_request
    end
    if @information_request.information_requestable_type == 'Agency'
      redirect_to url_for('/contact')
    else
      redirect_to listing_path(@information_request.information_requestable_id,
        :anchor => 'information_request')
    end
  end


  private

  # If nested, set parent instance variable
  def set_information_requestable
    if params[:context_type]
      @information_requestable = context_object(
        :include => :information_requests )
    end
  end
end
