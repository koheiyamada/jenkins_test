class Tu::SubjectsController < ApplicationController
  tutor_only
  layout 'with_sidebar'

  def index
    @subjects = Subject.page(params[:page])
    @my_subject_ids = current_user.subjects.select("subjects.id").map(&:id)
    @subjects.each do |subject|
      subject.selected = true if @my_subject_ids.include?(subject.id)
    end
  end

  def all
    @subjects = Subject.page(params[:page])
  end

  def my
    @subjects = current_user.subjects.page(params[:page])
  end

  # POST /tu/subjects/:id/select
  def select
    @subject = Subject.find(params[:id])
    current_user.subjects << @subject
    redirect_to action:"index"
  end

  # POST /tu/subjects/:id/deselect
  def deselect
    @subject = Subject.find(params[:id])
    current_user.subjects.delete(@subject)
    redirect_to action:"index"
  end
end
