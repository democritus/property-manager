class UsersController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  # GET /users/1
  # GET /users/1.xml
  def show
    #@user = User.find(params[:id])
    @user = @current_user

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    #@user = User.find(params[:id])
    @user = @current_user
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    #@user = User.find(params[:id])
    @user = @current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        #format.html { redirect_to(@user) }
        format.html { redirect_to account_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end

