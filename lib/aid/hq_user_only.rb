module Aid
  module HqUserOnly
    before_filter :authenticate_hq_user!

    private

      def authenticate_hq_user!
        raise "hehehe"
        authenticate_user! && unless current_user.hq_user?
          redirect_to new_user_session_path
        end
      end
  end
end
