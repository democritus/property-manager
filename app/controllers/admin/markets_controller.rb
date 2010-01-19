class Admin::MarketsController < Admin::AdminController

  before_filter :require_user, :except => :index
  before_filter :set_contextual_country
  
  # GET /markets
  # GET /markets.xml
  def index
    if @country
      @markets = @country.markets
    else
      @markets = Market.all
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /markets/1
  # GET /markets/1.xml
  def show
    @market = Market.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /markets/new
  # GET /markets/new.xml
  def new
    @market = Market.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /markets/1/edit
  def edit
    @market = Market.find(params[:id])
  end

  # POST /markets
  # POST /markets.xml
  def create
    if @country
      @market = @country.markets.build(params[:market])
    else
      @market = Market.new(params[:market])
    end

    respond_to do |format|
      if @market.save
        flash[:notice] = 'Market was successfully created.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /markets/1
  # PUT /markets/1.xml
  def update
    @market = Market.find(params[:id])

    respond_to do |format|
      if @market.update_attributes(params[:market])
        flash[:notice] = 'Market was successfully updated.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /markets/1
  # DELETE /markets/1.xml
  def destroy
    @market = Market.find(params[:id])
    @market.destroy

    respond_to do |format|
      format.html { redirect_to(country_market_url(@market.country, @market)) }
    end
  end
  
  
  private

  # If nested, set parent instance variable
  def set_contextual_country
    if params[:context_type] == 'countries'
      @country = context_object( :include => :markets )
    end
  end

  # Allow nested access /countries/1/markets/1 or not nested access /markets/1
  def context_url
    if params[:context_type] == 'countries'
      admin_country_url(@country)
    else
      admin_market_url(@market)
    end
  end
end

