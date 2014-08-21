class Bs::Meetings::FormsController < MeetingFormsController
  bs_user_only

  private

    def finish_wizard_path
      scheduling_bs_meetings_path
    end
end
