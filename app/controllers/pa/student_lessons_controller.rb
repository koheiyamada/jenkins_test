class Pa::StudentLessonsController < LessonsController
  include ParentAccessControl
  parent_only
  layout 'with_sidebar'
  before_filter :prepare_student

  private

    def subject
      @student
    end
end
