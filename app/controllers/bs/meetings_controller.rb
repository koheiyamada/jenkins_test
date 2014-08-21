class Bs::MeetingsController < MeetingsController
  bs_user_only

  private

    def path_after_close
      new_bs_meeting_report_path(@meeting)
    end
end
