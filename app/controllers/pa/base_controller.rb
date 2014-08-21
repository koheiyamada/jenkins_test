class Pa::BaseController < ApplicationController
  parent_only
  layout 'with_sidebar'

  private

    def authenticate_parent!
      authenticate_user! && unless current_user.parent?
        redirect_to new_user_session_path
      end
    end

end
