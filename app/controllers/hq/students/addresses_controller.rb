class Hq::Students::AddressesController < ApplicationController
  hq_user_only
  layout 'with_sidebar'
  before_filter :prepare_student

  def show
    @address = @student.address
  end

  def edit
    @address = @student.address
  end

  def update
    @address = @student.address
    if @address.update_attributes(params[:address])
      redirect_to({action:'show'}, notice:t('messages.address_changed'))
    else
      render 'edit'
    end
  end
end
