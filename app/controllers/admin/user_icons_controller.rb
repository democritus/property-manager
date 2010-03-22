class Admin::UserIconsController < Admin::AdminController

  before_filter :set_user_iconable
  
  # GET /user_icons
  # GET /user_icons.xml
  def index
    @user_icons = @user_iconable.users_icons

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /user_icons/new
  # GET /user_icons/new.xml
  def new
    @user_icon = UserIcon.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_icon }
    end
  end

  # GET /user_icons/1/edit
  def edit
    @user_icon = UserIcon.find(params[:id])
  end

  # POST /user_icons
  # POST /user_icons.xml
  def create
    @user_icon = @user_iconable.user_icons.build( params[:user_icon] )

    respond_to do |format|
      if @user_icon.save
        flash[:notice] = 'UserIcon was successfully created.'
        format.html { redirect_to(
          polymorphic_url(:admin, [@user_iconable, :user_icons])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /user_icons/1
  # PUT /user_icons/1.xml
  def update
    @user_icon = UserIcon.find(params[:id])

    respond_to do |format|
      if @user_icon.update_attributes(params[:user_icon])
        flash[:notice] = 'UserIcon was successfully updated.'
        format.html { redirect_to(:admin,
          polymorphic_url([@user_iconable, :user_icons])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /user_icons/1
  # DELETE /user_icons/1.xml
  def destroy
    @user_icon = UserIcon.find(params[:id])
    @user_icon.destroy

    respond_to do |format|
      format.html { redirect_to(
        polymorphic_url(:admin, [@user_iconable, :user_icons])) }
    end
  end
  
  
  private

  # If nested, set parent instance variable
  def set_user_iconable
    unless params[:context_type].nil?
      @user_iconable = context_object( :include => :user_icons )
    end
  end
  
end
