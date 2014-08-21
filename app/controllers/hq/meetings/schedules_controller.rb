class Hq::Meetings::SchedulesController < Meetings::SchedulesController
  hq_user_only
  include HqUserAccessControl
  access_control :meeting

  private

    def redirect_path_on_selected
      hq_meeting_path @meeting
    end

    def redirect_path_on_updated
      hq_meeting_path @meeting
    end

    def redirect_path_on_deleted
      hq_meeting_path @meeting
    end

    def prepare_meeting
      # 本部アカウントはすべての面談データにアクセスできる。
      @meeting = Meeting.find(params[:meeting_id])
    end
end
