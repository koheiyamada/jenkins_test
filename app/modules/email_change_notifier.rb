module EmailChangeNotifier
  def self.included(base)
    base.after_update :on_email_changed, if: :emails_changed?
  end

  private
    def on_email_changed
      # This method should be overwritten by the including class
    end

    def emails_changed?
      email_changed? || phone_email_changed?
    rescue => e
      logger.error e
      false
    end
end