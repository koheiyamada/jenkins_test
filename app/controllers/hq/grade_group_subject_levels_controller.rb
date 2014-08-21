class Hq::GradeGroupSubjectLevelsController < SubjectLevelsController
  hq_user_only
  layout 'with_sidebar'

  before_filter do
    @grade_group = GradeGroup.find(params[:grade_group_id])
    @subject = @grade_group.subjects.find(params[:subject_id])
  end

  def index
    redirect_to hq_grade_group_subject_path(@grade_group, @subject)
  end

  def new
    @subject_level = @subject.levels.build
  end

  def create
    @level = @subject.levels.build(params[:subject_level])
    if @level.save
      redirect_to action: :index
    else
      render :new
    end
  end
end
