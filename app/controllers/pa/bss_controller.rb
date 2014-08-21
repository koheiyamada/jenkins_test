class Pa::BssController < ApplicationController
  include ParentAccessControl
  parent_only
  layout 'with_sidebar'

  def index
    @bss = current_user.bss
  end

  def show
    @bs = current_user.bss.find(params[:id])
  end
end
