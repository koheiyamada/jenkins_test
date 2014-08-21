class Admin::HomeController < ApplicationController
  system_admin_only
  layout 'with_sidebar'

  def index

  end
end
