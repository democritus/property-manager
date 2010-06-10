class Admin::BarriosController < Admin::AdminController

  before_filter :set_contextual_market
  
  def index
    if @market
      @barrios = @market.barrios
    else
      @barrios = Barrio.all
    end
  end
  
  def show
    @barrio = Barrio.find(params[:id])
  end

  def new
    @barrio = Barrio.new
  end

  def edit
    @barrio = Barrio.find(params[:id])
  end

  def create
    if @market
      @barrio = @market.barrios.build(params[:barrio])
    else
      @barrio = Barrio.new(params[:barrio])
    end
    if @barrio.save
      flash[:notice] = 'Barrio was successfully created.'
      redirect_to(context_url)
    else
      render :new
    end
  end

  def update
    @barrio = Barrio.find(params[:id])
    if @barrio.update_attributes(params[:barrio])
      flash[:notice] = 'Barrio was successfully updated.'
      redirect_to(context_url)
    else
      render :edit
    end
  end

  def destroy
    @barrio = Barrio.find(params[:id])
    @barrio.destroy
    redirect_to(market_barrio_url(@barrio.market, @barrio)) }
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
      lists[:cantons] = Canton.find(:all,
        :include => nil,
        :conditions => conditions.merge(
          :province_id => params[:province_id]
        ),
        :select => 'id, name'
      ).map { |canton| [canton.name, canton.id] }
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

  # Allow nested access /markets/1/barrios/1 or not nested access /barrios/1
  def context_url
    if params[:context_type] == 'markets'
      admin_market_url(@market)
    else
      admin_barrio_url(@barrio)
    end
  end
end
