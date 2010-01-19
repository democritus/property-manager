class Admin::AgentAffiliationsController < Admin::AdminController

  before_filter :require_user, :only => [:index, :new, :create, :edit, :update,
    :destroy]
  before_filter :set_affiliable

  # GET /agent_affiliations
  # GET /agent_affiliations.xml
  def index
    @agent_affiliations = @affiliable.agent_affiliations

    # Data for lists
    set_form_list_data

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /agent_affiliations/1
  # GET /agent_affiliations/1.xml
  def show
    @agent_affiliation = AgentAffiliation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /agent_affiliations/new
  # GET /agent_affiliations/new.xml
  def new
    @agent_affiliation = AgentAffiliation.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /agent_affiliations/1/edit
  def edit
    @agent_affiliation = AgentAffiliation.find(params[:id])
  end

  # POST /agent_affiliations
  # POST /agent_affiliations.xml
  def create
    @agent_affiliation = @affilable.agent_affiliations.build(
      params[:agent_affiliation] )

    respond_to do |format|
      if @agent_affiliation.save
        flash[:notice] = 'AgentAffiliation was successfully created.'
        format.html { redirect_to(
          polymorphic_url(:admin, [@affiliable, :agent_affiliations])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /agent_affiliations/1
  # PUT /agent_affiliations/1.xml
  def update
    @agent_affiliation = AgentAffiliation.find(params[:id])

    respond_to do |format|
      if @agent_affiliation.update_attributes(params[:agent_affiliation])
        flash[:notice] = 'AgentAffiliation was successfully updated.'
        format.html { redirect_to(
          polymorphic_url(:admin, [@affiliable, :agent_affiliations])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /agent_affiliations/1
  # DELETE /agent_affiliations/1.xml
  def destroy
    @agent_affiliation = AgentAffiliation.find(params[:id])
    @agent_affiliation.destroy

    respond_to do |format|
      format.html { redirect_to(admin_agent_affiliations_url) }
    end
  end


  private

  # If nested, set parent instance variable
  def set_affiliable
    unless params[:context_type].nil?
      @affiliable = context_object( :include => :agent_affiliations )
    end
  end

end

