class BsAppFormsController < ApplicationController
  before_filter :check_already_confirmed, :only => [:show, :edit, :update, :confirm]

  def first
  end

  def agree
    session[:agreed_to_pledge] = true
    redirect_to action:"new"
  end

  def disagree
    session[:agreed_to_pledge] = nil
    redirect_to root_path
  end

  def new
    @bs_app_form = BsAppForm.new do |form|
      form.address = Address.new
      form.representative_birthday = 40.years.ago.beginning_of_year
      d = 3.days.from_now
      form.interview_datetime_1 = d
      form.interview_datetime_2 = d.tomorrow
      form.interview_datetime_3 = 2.days.since(d)
      form.os = OperatingSystem.default
    end
  end

  def create
    @bs_app_form = BsAppForm.new(params[:bs_app_form]) do |form|
      form.address = Address.new(params[:address])
      form.how_to_find = params[:how_to_find]
    end
    if @bs_app_form.save
      redirect_to bs_app_form_path(@bs_app_form)
    else
      render action: :new
    end
  end

  def show
    @bs_app_form = BsAppForm.find(params[:id])
    @bs_app_form.load_questionnaire_answers
  end

  def edit
    @bs_app_form = BsAppForm.find(params[:id])
    @bs_app_form.load_questionnaire_answers
  end

  def update
    @bs_app_form = BsAppForm.find(params[:id])
    @bs_app_form.address = Address.new(params[:address])
    @bs_app_form.how_to_find = params[:how_to_find]
    @bs_app_form.attributes = params[:bs_app_form]
    if @bs_app_form.save
      redirect_to action:"show"
    else
      render action:"edit"
    end
  end

  def confirm
    @bs_app_form = BsAppForm.find(params[:id])
    @bs_app_form.confirm!
    redirect_to action:"accepted"
  end

  def accepted
    @bs_app_form = BsAppForm.find(params[:id])
  end

  private

    def check_already_confirmed
      @bs_app_form = BsAppForm.find(params[:id])
      if @bs_app_form.confirmed?
        redirect_to action:"accepted"
      end
    end
end
