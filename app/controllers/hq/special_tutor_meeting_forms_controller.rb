class Hq::SpecialTutorMeetingFormsController < SpecialTutorMeetingFormsController
  hq_user_only

  private

    def finish_wizard_path
      scheduling_hq_meetings_path
    end
end
