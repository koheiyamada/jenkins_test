class Hq::SubjectsController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def index
    @subjects = Subject.all
  end

  def show
    @subject = Subject.find(params[:id])
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(params[:subject])
    if @subject.save
      redirect_to action:"index"
    else
      render action:"new"
    end
  end

  def destroy
    @subject = Subject.find(params[:id])
    if @subject.has_future_lessons?
      redirect_to({action:"show"}, alert:t("messages.cannot_destroy_subject_because_of_future_lessons"))
    elsif @subject.tutors.any?
      redirect_to({action:"show"}, alert:t("messages.cannot_destroy_subject_because_of_tutors"))
    else
      @subject.destroy
      redirect_to action:"index"
    end
  end
end
