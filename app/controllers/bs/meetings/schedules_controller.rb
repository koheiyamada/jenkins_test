class Bs::Meetings::SchedulesController < Meetings::SchedulesController
  bs_user_only

  private

    def redirect_path_on_selected
      bs_meeting_path @meeting
    end

    def redirect_path_on_updated
      bs_meeting_path @meeting
    end

    def redirect_path_on_deleted
      bs_meeting_path @meeting
    end
end
