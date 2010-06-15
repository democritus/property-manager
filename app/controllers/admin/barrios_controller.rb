class Admin::BarriosController < Admin::AdminController

  include UpdatePlaces # AJAX to update form select lists

  before_filter :set_contextual_canton
  
  def index
    if @canton
      @barrios = @canton.barrios
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
    if @canton
      @barrio = @canton.barrios.build(params[:barrio])
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
    redirect_to(canton_barrio_url(@barrio.canton, @barrio)) }
  end


  private

  # If nested, set parent instance variable
  def set_contextual_canton
    if params[:context_type] == 'cantons'
      @canton = context_object( :include => :barrios )
    end
  end

  # Allow nested access /cantons/1/barrios/1 or not nested access /barrios/1
  def context_url
    if params[:context_type] == 'cantons'
      admin_canton_url(@canton)
    else
      admin_barrio_url(@barrio)
    end
  end
end
