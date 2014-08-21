class Bs::SpecialTutorMeetingFormsController < SpecialTutorMeetingFormsController
  bs_user_only

  private

    def finish_wizard_path
      scheduling_bs_meetings_path
    end
end
