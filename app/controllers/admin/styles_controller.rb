class Admin::StylesController < Admin::AdminController
  
  # GET /styles
  # GET /styles.xml
  def index
    @styles = Style.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /styles/1
  # GET /styles/1.xml
  def show
    @style = Style.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /styles/new
  # GET /styles/new.xml
  def new
    @style = Style.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /styles/1/edit
  def edit
    @style = Style.find(params[:id])
  end

  # POST /styles
  # POST /styles.xml
  def create
    @style = Style.new(params[:style])

    respond_to do |format|
      if @style.save
        flash[:notice] = 'Style was successfully created.'
        format.html { redirect_to(admin_style_url(@style)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /styles/1
  # PUT /styles/1.xml
  def update
    @style = Style.find(params[:id])

    respond_to do |format|
      if @style.update_attributes(params[:style])
        flash[:notice] = 'Style was successfully updated.'
        format.html { redirect_to(admin_style_url(@style)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /styles/1
  # DELETE /styles/1.xml
  def destroy
    @style = Style.find(params[:id])
    @style.destroy

    respond_to do |format|
      format.html { redirect_to(admin_styles_url) }
      format.xml  { head :ok }
    end
  end
end
