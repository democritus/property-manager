class Admin::BarriosController < Admin::AdminController

  before_filter :require_user
  before_filter :set_contextual_market
  
  # GET /barrios
  # GET /barrios.xml
  def index
    if @market
      @barrios = @market.barrios
    else
      @barrios = Agent.all
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /barrios/1
  # GET /barrios/1.xml
  def show
    @barrio = Barrio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /barrios/new
  # GET /barrios/new.xml
  def new
    @barrio = Barrio.new
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /barrios/1/edit
  def edit
    @barrio = Barrio.find(params[:id])
  end

  # POST /barrios
  # POST /barrios.xml
  def create
    if @market
      @barrio = @market.barrios.build(params[:barrio])
    else
      @barrio = Barrio.new(params[:barrio])
    end

    respond_to do |format|
      if @barrio.save
        flash[:notice] = 'Barrio was successfully created.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /barrios/1
  # PUT /barrios/1.xml
  def update
    @barrio = Barrio.find(params[:id])

    respond_to do |format|
      if @barrio.update_attributes(params[:barrio])
        flash[:notice] = 'Barrio was successfully updated.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /barrios/1
  # DELETE /barrios/1.xml
  def destroy
    @barrio = Barrio.find(params[:id])
    @barrio.destroy

    respond_to do |format|
      format.html { redirect_to(market_barrio_url(@barrio.market, @barrio)) }
    end
  end
  
  # AJAX target for constraining provinces, zones, and markets by country
  def update_places
    lists = {}
    unless params[:country_id].blank?
      conditions = { :country_id => params[:country_id] }
      lists[:provinces] = Province.find(:all,
        :include => nil,
        :conditions => conditions,
        :select => 'id, name'
      ).map { |province| [province.name, province.id] }
      lists[:zones] = Zone.find(:all,
        :include => nil,
        :conditions => conditions,
        :select => 'id, name'
      ).map { |zone| [zone.name, zone.id] }
      lists[:markets] = Market.find(:all,
        :include => nil,
        :conditions => conditions,
        :select => 'id, name'
      ).map { |market| [market.name, market.id] }
    end
    
    render :partial => 'update_places',
      :layout => false,
      :locals => { :lists => lists }
  end


  private

  # If nested, set parent instance variable
  def set_contextual_market
    if params[:context_type] == 'markets'
      @market = context_object( :include => :barrios )
    end
  end

  # Allow nested access /countries/1/barrios/1 or not nested access /barrios/1
  def context_url
    if params[:context_type] == 'markets'
      admin_market_url(@market)
    else
      admin_barrio_url(@barrio)
    end
  end
end

