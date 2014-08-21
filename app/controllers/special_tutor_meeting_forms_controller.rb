# coding:utf-8

class SpecialTutorMeetingFormsController < MeetingFormsController
  before_filter do
    # 親クラスのステップ定義を上書きする
    self.steps = [:special_tutor, :member_type, :student, :parent, :schedule, :confirmation]
  end

  def special_tutor
    if request.get?
      if @meeting.have_enough_members?
        redirect_to wizard_path(:schedule)
      else
        @tutors = special_tutors
        render_wizard
      end
    else
      @meeting.members << current_user.special_tutors.find(params[:tutor_id])
      if @meeting.save
        redirect_to wizard_path(:schedule)
      else
        render action: 'parent'
      end
    end
  end

  def special_tutors
    exclusions = @meeting.member_ids
    if params[:q]
      current_user.search_tutors(params[:q], active: true, special: true).select{|s| !exclusions.include?(s.id)}
    else
      if exclusions.present?
        current_user.special_tutors.only_active.where('users.id NOT IN (?)', exclusions).page(params[:page])
      else
        current_user.special_tutors.only_active.page(params[:page])
      end
    end
  end
end
