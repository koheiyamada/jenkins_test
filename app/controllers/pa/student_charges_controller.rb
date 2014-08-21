class Pa::StudentChargesController < ApplicationController
  include ParentAccessControl
  parent_only
  layout 'with_sidebar'

  def edit
    @student = current_user.students.find(params[:student_id])
    @student_settings = @student.settings
  end

  def update
    @student = current_user.students.find(params[:student_id])
    @student_settings = @student.settings
    if @student_settings.update_attributes(params[:student_settings])
      redirect_to edit_pa_student_charge_path(@student), notice:t('messages.updated')
    else
      render action: 'edit'
    end
  end
end
