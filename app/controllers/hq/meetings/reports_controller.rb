class Hq::Meetings::ReportsController < MeetingReportsController
  hq_user_only

  private

    def prepare_meeting
      @meeting = Meeting.find(params[:meeting_id])
    end
end
