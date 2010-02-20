class Admin::SiteTextsController < Admin::AdminController

  before_filter :set_contextual_agency

  def index
    @site_texts = @agency.site_texts
  end
  
  def show
    @site_text = SiteText.find(params[:id])
  end
  
  def new
    @site_text = SiteText.new
  end
  
  def create
    @site_text = @agency.site_texts.build(params[:site_text])
    if @site_text.save
      flash[:notice] = "Successfully created site text."
      redirect_to admin_agency_site_text_url(@agency, @site_text)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @site_text = SiteText.find(params[:id])
  end
  
  def update
    @site_text = SiteText.find(params[:id])
    if @site_text.update_attributes(params[:site_text])
      flash[:notice] = "Successfully updated site text."
      redirect_to admin_agency_site_text_url(@agency, @site_text)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @site_text = SiteText.find(params[:id])
    @site_text.destroy
    flash[:notice] = "Successfully destroyed site text."
    redirect_to agency_site_texts_url(@agency)
  end

  
  private

  def set_contextual_agency
    if params[:context_type] == 'agencies'
      @agency = context_object( :include => :site_texts )
    end
  end
end
