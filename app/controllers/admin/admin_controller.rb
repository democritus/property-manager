class Admin::AdminController < ApplicationController

  before_filter :require_user
  
  layout 'admin/layouts/admin'
  
  helper :multiple_select
end
