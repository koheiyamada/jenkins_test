class St::ChargeSettingsController < ApplicationController
  include StudentAccessControl
  student_only
  layout 'with_sidebar'
  before_filter :only_independent

  def show
    @student_settings = current_user.settings
  end

  def edit
    @student_settings = current_user.settings
  end

  def update
    @student_settings = current_user.settings
    if @student_settings.update_attributes(params[:student_settings])
      redirect_to action: 'show'
    else
      render action: 'edit'
    end
  end

  private

    def only_independent
      unless current_user.independent?
        redirect_to st_root_path
      end
    end
end
