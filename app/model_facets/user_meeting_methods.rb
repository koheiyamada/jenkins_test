module UserMeetingMethods

  def self.included(base)
    base.has_many :meeting_members
    base.has_many :meetings, through: :meeting_members

    base.before_destroy do
      remove_meetings
    end

    base.before_update do
      if leaving?
        remove_meetings
      end
    end
  end

  def can_finish_meeting?(meeting)
    hq_user? || bs_user?
  end

  def can_see_meeting_report?(meeting_report)
    meeting_report.present? && (hq_user? || meeting_report.author == self)
  end

  def can_write_meeting_report?(meeting)
    meeting.held? && meeting.meeting_report.blank? && meeting.member?(self) && (hq_user? || bs_user?)
  end

  def meeting_count
    meeting_members.done.count
  end

  private

    # 参加する（した）面談データを全て削除する
    def remove_meetings
      # meetings.destroy_allだと中間テーブルのデータしか削除されない。
      meetings.each do |meeting|
        meeting.destroy
      end
    end
end