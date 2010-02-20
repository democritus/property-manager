class Admin::AdminController < ApplicationController

  before_filter :require_user
  
  layout 'admin/layouts/admin'
end
