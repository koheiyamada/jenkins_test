class TutorAppFormsController < ApplicationController
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
    if session[:agreed_to_pledge].blank?
      redirect_to action:"first"
    end
    @tutor_app_form = TutorAppForm.new do |form|
      form.current_address = CurrentAddress.new
      form.hometown_address = HometownAddress.new
      #form.grade = 1
      d = 3.days.from_now
      form.interview_datetime_1 = d
      form.interview_datetime_2 = d.tomorrow
      form.interview_datetime_3 = 2.days.since(d)
      form.birthday = 20.years.ago.beginning_of_year
      form.special_tutor = false
      form.os = OperatingSystem.default
    end
  end

  def create
    @tutor_app_form = TutorAppForm.new(params[:tutor_app_form]) do |form|
      form.current_address = CurrentAddress.new(params[:current_address])
      form.how_to_find = params[:how_to_find]
    end
    if  @tutor_app_form.save
      redirect_to tutor_app_form_path(@tutor_app_form)
    else
      render action: :new
    end
  end

  def show
    @tutor_app_form = TutorAppForm.find(params[:id])
  end

  def edit
    @tutor_app_form = TutorAppForm.find(params[:id])
    @tutor_app_form.load_questionnaire_answers
  end

  def update
    @tutor_app_form = TutorAppForm.find(params[:id])
    @tutor_app_form.current_address = CurrentAddress.new(params[:current_address])
    @tutor_app_form.how_to_find = params[:how_to_find]
    @tutor_app_form.attributes = params[:tutor_app_form]
    if @tutor_app_form.save
      redirect_to action:"show"
    else
      render action:"edit"
    end
  end

  def confirm
    @tutor_app_form = TutorAppForm.find(params[:id])
    @tutor_app_form.confirm!
    redirect_to action:"accepted"
  end

  def accepted
    @tutor_app_form = TutorAppForm.find(params[:id])
  end

  private

    def check_already_confirmed
      @tutor_app_form = TutorAppForm.find(params[:id])
      if @tutor_app_form.confirmed?
        redirect_to action:"accepted"
      end
    end
end
