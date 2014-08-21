# coding:utf-8
# (本部またはBS)-(スペシャルチューター)-(保護者または受講者)の三者で行われる面談
class SpecialTutorMeeting < Meeting

  def have_enough_members?
    members.count > 2
  end

end
