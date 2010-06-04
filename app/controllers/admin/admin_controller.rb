class Admin::AdminController < ApplicationController

  before_filter :require_user
  cache_sweeper :site_sweeper, :only => [ :create, :update, :destroy ]
  
  layout 'admin/layouts/admin'
  
  helper :multiple_select
end
