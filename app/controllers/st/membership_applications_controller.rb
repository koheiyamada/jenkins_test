class St::MembershipApplicationsController < MembershipApplicationsController
  student_only
  layout 'registration-centered'

  def show
    @membership_application = current_user.membership_application
  end

  def complete
    redirect_to action: :entry_fee
  end

  private
    def path_on_created
      # 入会申込登録後は入会費の案内に移動する。
      {action: :complete}
    end
end
