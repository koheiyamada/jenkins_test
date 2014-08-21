class St::MyMessagesController < MyMessagesController
  include StudentAccessControl
  student_only
  before_filter :add_bs_owner_when_coach_is_recipient, only: :new

  private

    def add_bs_owner_when_coach_is_recipient
      if @recipients.present? && @recipients.count == 1
        user = @recipients.first
        if user.is_a? Coach
          bs_owner = user.bs_owner
          if bs_owner.present? && bs_owner != user
            @recipients << bs_owner
          end
        end
      end
    end
end
