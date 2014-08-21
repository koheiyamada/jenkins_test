class Admin::JobsController < ApplicationController
  system_admin_only
  layout 'with_sidebar'

  def index
    @jobs = Delayed::Job.order('run_at').page(params[:page])
  end

  def failed
    @jobs = Delayed::Job.where('failed_at IS NOT NULL').order('run_at').page(params[:page])
    render :index
  end

  def stat
    @jobs = Delayed::Job.scoped
  end

  def show
    @job = Delayed::Job.find(params[:id])
  end
end
