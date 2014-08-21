class TeachingSubjectsController < ApplicationController
  layout 'with_sidebar'
  before_filter :prepare_tutor

  def index
    @subject_levels = subject.subject_levels.includes(:subject => :grade_group).order('grade_groups.grade_group_order, subjects.id')
  end

  def show
    @teaching_subject = subject.teaching_subjects.includes(:subject, :grade_group).find(params[:id])
  end

  def new
    @teaching_subject = TeachingSubject.new
  end

  # GET teaching_subjects/edit
  def edit
    @grade_groups = GradeGroup.by_group_order
    @tutor = subject
  end

  # PUT teaching_subjects
  def update
    subject.subject_levels = SubjectLevel.where(id: params[:subject_levels])
    redirect_to action: :index
  end

  private

    def subject
      current_user
    end

    def parse_teaching_subjects
      params[:subjects].each_with_object([]) do |(subject_id, level), teaching_subjects|
        subject_level = SubjectLevel.where(subject_id: subject_id, level: level).first
        if subject_level.present?
          if subject_level.level > 0
            teaching_subjects << TeachingSubject.new(subject_level: subject_level, level: level)
          end
        end
      end
    end
end
