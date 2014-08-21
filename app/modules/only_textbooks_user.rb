module OnlyTextbooksUser
  def self.included(base)
    class << base
      def only_textbooks_user(options={})
        before_filter :only_textbooks_user, options
      end
    end
  end

  private

  def only_textbooks_user
    unless current_user.use_textbooks?
      redirect_to redirect_url_for_no_textbook_user
    end
  end

  def redirect_url_for_no_textbook_user
    {action: "index"}
  end
end