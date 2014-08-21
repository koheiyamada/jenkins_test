class Hq::Tutors::TeachingSubjectsController < TeachingSubjectsController
  include HqUserAccessControl
  hq_user_only
  access_control :tutor
  before_filter :prepare_tutor

  private

    def subject
      @tutor
    end
end
