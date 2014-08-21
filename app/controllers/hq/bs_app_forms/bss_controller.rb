class Hq::BsAppForms::BssController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :bs
  layout 'with_sidebar'
  before_filter :prepare_bs_app_form
  after_filter :migrate_student_to_new_bs, :only => :create

  def show
    @bs = @bs_app_form.bs
  end

  def new
    @bs = @bs_app_form.new_bs
  end

  def create
    @bs = Bs.new(params[:bs]) do |bs|
      bs.address = Address.new(params[:address])
    end
    if @bs.save
      @bs_app_form.update_attribute :bs_id, @bs.id
      redirect_to new_hq_bs_app_form_bs_bs_user_path(@bs_app_form)
    else
      render action:"new"
    end
  end

  private

    def prepare_bs_app_form
      @bs_app_form = BsAppForm.find(params[:bs_app_form_id])
    end

    def migrate_student_to_new_bs
      if @bs.persisted?
        Delayed::Job.enqueue StudentsMigrationJob.new(@bs.id)
      end
    end
end
