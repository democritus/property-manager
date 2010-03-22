class Admin::MarketSegmentsController < Admin::AdminController
  
  def index
    @market_segments = MarketSegment.all
  end
  
  def show
    @market_segment = MarketSegment.find(params[:id])
  end
  
  def new
    @market_segment = MarketSegment.new
  end
  
  def create
    @market_segment = MarketSegment.new(params[:market_segment])
    if @market_segment.save
      flash[:notice] = "Successfully created market segment."
      redirect_to admin_market_segment_url(@market_segment)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @market_segment = MarketSegment.find(params[:id])
  end
  
  def update
    @market_segment = MarketSegment.find(params[:id])
    if @market_segment.update_attributes(params[:market_segment])
      flash[:notice] = "Successfully updated market segment."
      redirect_to admin_market_segment_url(@market_segment)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @market_segment = MarketSegment.find(params[:id])
    @market_segment.destroy
    flash[:notice] = "Successfully destroyed market segment."
    redirect_to admin_market_segments_url
  end
end
