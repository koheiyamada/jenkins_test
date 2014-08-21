module MeetingsHelper
  def meeting_status(meeting)
    t('meeting.status.' + meeting.status)
  end
end