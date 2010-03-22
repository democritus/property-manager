class Admin::AgenciesController < Admin::AdminController

  protect_from_forgery :except => [
    :auto_complete_for_agency_broker_id
  ]
  
  # REMOVED: used to include non-admin helpers
  #helper self.name.demodulize.underscore.chomp('_controller').to_sym

  # GET /agencies
  # GET /agencies.xml
  def index
    @agencies = Agency.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /agencies/1
  # GET /agencies/1.xml
  def show
    infer_agency
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
      
  # GET /agencies/new
  # GET /agencies/new.xml
  def new
    @agency = Agency.new
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /agencies/1/edit
  def edit
    @agency = Agency.find(params[:id], :include => :markets)
  end

  # POST /agencies
  # POST /agencies.xml
  def create
    @agency = Agency.new(params[:agency])
    
    respond_to do |format|
      if @agency.save
        flash[:notice] = 'Agency was successfully created.'
        # Redirect to agent affiliation form if no agents associated        
        format.html { redirect_to(admin_agency_url(@agency)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /agencies/1
  # PUT /agencies/1.xml
  def update
    @agency = Agency.find(params[:id])
    
    respond_to do |format|
      if @agency.update_attributes(params[:agency])
        flash[:notice] = 'Agency was successfully updated.'
        format.html { redirect_to(admin_agency_url(@agency)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /agencies/1
  # DELETE /agencies/1.xml
  def destroy
    @agency = Agency.find(params[:id])
    @agency.destroy

    respond_to do |format|
      format.html { redirect_to(admin_agencies_url) }
    end
  end

  # Request information about a property
  def request_info
    # Validate data
    if params[:name].blank?
      flash[:error] = 'Name is required.'
    end
    if params[:email].blank? && params[:phone].blank?
      flash[:error] = 'Either an email address or phone number is required.'
    end
    # Send email to broker
    
  end
  
  def auto_complete_for_agency_broker_id
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
      " OR agents.id = :y"
    search_sql_hash = { :x => '%' + params[:agency][:broker_id].downcase + '%',
      :y => params[:agency][:broker_id] }
    find_options = {
      :joins => 'LEFT JOIN `users` ON `users`.`id` = `agents`.`user_id`',
      :conditions => [ search_sql, search_sql_hash ],
      :select => "CONCAT(agents.id, ' - ', " + name_sql + ", users.login" + 
        ", ', ', users.email) AS user_info",
      :order => "users.login ASC",
      :limit => 10 }
    @agents = Agent.find(:all, find_options)
    render :inline => "<%= auto_complete_result @agents, :user_info %>"
    #render :layout => false
  end
  
  # AJAX target for updating country-related selects
  def country_pivot
    ajax = {}
    unless params[:country_id].blank?
      conditions = { :country_id => params[:country_id] }
      ajax[:markets] = Market.find(:all,
        :include => nil,
        :conditions => conditions,
        :select => 'id, name'
      ).map { |market| [market.name, market.id] }
      ajax[:partner_agencies] = Agency.find(:all,
        :include => nil,
        :conditions => conditions,
        :select => 'id, name'
      ).map { |agency| [agency.name, agency.id] }
    end
    
    # Look up selected items
    agency_id = params[:agency_id].to_i
    ajax[:market_ids] = []
    ajax[:partner_agency_ids] = []
    unless agency_id.zero?
      agency = Agency.find(agency_id,
        :include => [ :markets, :partner_agencies ]
      )
      if agency
        if agency.markets
          ajax[:market_ids] = agency.markets.map { |x| x.id }
        end
        if agency.partner_agencies
          ajax[:partner_agency_ids] = agency.partner_agencies.map { |x| x.id }
        end
      end
    end
    
    render :partial => 'country_pivot',
      :layout => false,
      :locals => { :ajax => ajax }
  end
  
  
  private
  
  def infer_agency
    if params[:id]
      @agency = Agency.find(params[:id])
    else
      @agency = active_agency
    end
  end
end

