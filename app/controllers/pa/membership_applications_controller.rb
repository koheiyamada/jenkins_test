class Pa::MembershipApplicationsController < MembershipApplicationsController
  parent_only
  layout 'registration-centered'

  def show
    @membership_application = current_user.membership_application
  end

  def complete
    redirect_to action: :entry_fee
  end

  private

    def path_on_created
      {action: :complete}
    end
end
