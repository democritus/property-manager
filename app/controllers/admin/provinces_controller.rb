class Admin::ProvincesController < Admin::AdminController

  before_filter :set_contextual_country
  
  # GET /provinces
  # GET /provinces.xml
  def index
    if @country
      @provinces = @country.provinces
    else
      @provinces = Province.all
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /provinces/1
  # GET /provinces/1.xml
  def show
    @province = Province.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /provinces/new
  # GET /provinces/new.xml
  def new
    @province = Province.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /provinces/1/edit
  def edit
    @province = Province.find(params[:id])
  end

  # POST /provinces
  # POST /provinces.xml
  def create
    if @country
      @province = @country.provinces.build(params[:province])
    else
      @province = Province.new(params[:province])
    end

    respond_to do |format|
      if @province.save
        flash[:notice] = 'Province was successfully created.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /provinces/1
  # PUT /provinces/1.xml
  def update
    @province = Province.find(params[:id])

    respond_to do |format|
      if @province.update_attributes(params[:province])
        flash[:notice] = 'Province was successfully updated.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /provinces/1
  # DELETE /provinces/1.xml
  def destroy
    @province = Province.find(params[:id])
    @province.destroy

    respond_to do |format|
      format.html {
        redirect_to(admin_country_province_url(@province.country, @province)) }
    end
  end
  
  
  private

  # If nested, set parent instance variable
  def set_contextual_country
    if params[:context_type] == 'countries'
      @country = context_object( :include => :provinces )
    end
  end

  # Allow nested access /countries/1/provinces/1 or
  # not nested access /provinces/1
  def context_url
    if params[:context_type] == 'countries'
      admin_country_url(@country)
    else
      admin_province_url(@province)
    end
  end
end
