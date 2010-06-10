class Admin::CantonsController < Admin::AdminController

  before_filter :set_contextual_province
  
  def index
    if @province
      @cantons = @province.cantons
    else
      @cantons = Canton.all
    end
  end
  
  def show
    @canton = Canton.find(params[:id])
  end

  def new
    @canton = Canton.new
  end

  def edit
    @canton = Canton.find(params[:id])
  end

  def create
    if @province
      @canton = @province.cantons.build(params[:canton])
    else
      @canton = Canton.new(params[:canton])
    end
    if @canton.save
      flash[:notice] = 'Canton was successfully created.'
      redirect_to(context_url)
    else
      render :new
    end
  end

  def update
    @canton = Canton.find(params[:id])
    if @canton.update_attributes(params[:canton])
      flash[:notice] = 'Canton was successfully updated.'
      redirect_to(context_url)
    else
      render :edit
    end
  end

  def destroy
    @canton = Canton.find(params[:id])
    @canton.destroy
    redirect_to(province_canton_url(@canton.province, @canton)) }
  end
  
  # AJAX target for constraining provinces by country
  def update_places
    lists = {}
    unless params[:country_id].blank?
      conditions = { :country_id => params[:country_id] }
      lists[:provinces] = Province.find(:all,
        :include => nil,
        :conditions => conditions,
        :select => 'id, name'
      ).map { |province| [province.name, province.id] }
    end
    render :partial => 'update_places',
      :layout => false,
      :locals => { :lists => lists }
  end


  private

  # If nested, set parent instance variable
  def set_contextual_province
    if params[:context_type] == 'provinces'
      @province = context_object( :include => :cantons )
    end
  end

  # Allow nested access /provinces/1/cantons/1 or not nested access /cantons/1
  def context_url
    if params[:context_type] == 'provinces'
      admin_province_url(@province)
    else
      admin_canton_url(@canton)
    end
  end
end
