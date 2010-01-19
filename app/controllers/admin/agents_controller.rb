class Admin::AgentsController < Admin::AdminController

  before_filter :require_user, :except => :show
  before_filter :set_contextual_agency

  caches_page :snapshot
  
  # Auto complete
  # REMOVED: couldn't get conditions to merge, manually added method to
  # controller
  #auto_complete_for :user, :login
    # creates hidden method: auto_complete_for_agent_user_id

  protect_from_forgery :except => [
    :auto_complete_for_agent_user_id
  ]
    # script.aculo.us sends AJAX using POST instead of GET, so AJAX doesn't
    # work when protect_from_forgery is turned on

  # GET /agents
  # GET /agents.xml
  def index
    if @agency.blank?
      @agents = Agent.all
    else
      @agents = @agency.agents
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /agents/1
  # GET /agents/1.xml
  def show
    @agent = Agent.find(:first,
      :include => { :agencies => :agent_affiliations },
      :conditions => { :id => params[:id] }
    )
    #@agent = Agent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /agents/new
  # GET /agents/new.xml
  def new
    @agent = Agent.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /agents/1/edit
  def edit
    @agent = Agent.find(params[:id])
  end

  # POST /agents
  # POST /agents.xml
  def create
    if @agency.blank?
      @agent = Agent.new(params[:agent])
    else
      @agent = @agency.agents.build(params[:agent])
    end

    # REMOVED: I think this was unnecessary, since agency id should be inherited
    # when creating new record nested under agency
    #associate_agency_id_with_new_agent

    respond_to do |format|
      if @agent.save
        flash[:notice] = 'Agent was successfully created.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "new" }

      end
    end
  end

  # PUT /agents/1
  # PUT /agents/1.xml
  def update
    @agent = Agent.find(params[:id])

    respond_to do |format|
      if @agent.update_attributes(params[:agent])
        flash[:notice] = 'Agent was successfully updated.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /agents/1
  # DELETE /agents/1.xml
  def destroy
    @agent = Agent.find(params[:id])
    @agent.destroy

    respond_to do |format|
      format.html { redirect_to(context_url) }
    end
  end
  
  def auto_complete_for_agent_user_id
    # NULL values for user's name cause entire expression to return null, so
    # return blank string instead if name is null in database
    first_name = 'IF(users.first_name, users.first_name, "")'
    last_name = 'IF(users.last_name, users.last_name, "")'
    full_name = "TRIM(CONCAT(" + first_name + ", ' ', " + first_name + "))"
    name_sql = "IF(users.first_name AND users.last_name, " + full_name +
      " + ', ', '')"
    search_sql = "LOWER(users.login) LIKE :x" +
      " OR LOWER(users.email) LIKE :x" +
      " OR LOWER(TRIM(CONCAT(users.first_name, ' ', users.last_name))) LIKE :x" +
      " OR users.id = :y"
    search_sql_hash = { :x => '%' + params[:agent][:user_id].downcase + '%',
      :y => params[:agent][:user_id] }
    find_options = {
      :joins => 'LEFT JOIN `agents` ON `agents`.`user_id` = `users`.`id`',

# TEST - don't exclude users who are already agents
#      :conditions => [ search_sql, search_sql_hash ],

      :conditions => [
        "agents.id IS NULL" +
        " AND (" +
          search_sql + 
        ")",
        search_sql_hash
      ],

      :select => "CONCAT(users.id, ' - ', " + name_sql + ", users.login" + 
        ", ', ', users.email) AS user_info",
      :order => "users.login ASC",
      :limit => 10 }
    @users = User.find(:all, find_options)
    render :inline => "<%= auto_complete_result @users, :user_info %>"
    #render :layout => false
  end


  private

  # If nested, set parent instance variable
  def set_contextual_agency
    if params[:context_type] == 'agencies'
      @agency = context_object( :include => :agents )
    end
  end

  # Allow nested access /agency/1/agents/1 or not nested access /agents/1
  def context_url
    if params[:context_type] == 'agencies'
      admin_agency_url(@agency)
    else
      admin_agent_url(@agent)
    end
  end

  # REMOVED: is this necessary? Shouldn't nested routes already
  # provide the agency id?
  #def associate_agency_id_with_new_agent
  #  unless @agency.id.nil?
  #    unless @agent.agent_affiliations[0].nil?
  #      @agent.agent_affiliations[0][:agency_id] = @agency.id
  #    end
  #  end
  #end

end

