module SkypeIdHolder
  def self.included(base)
    base.extend ClassMethods
    base.validate :ensure_skype_id_format_is_correct, :on => :create
  end

  def self.skype_format
    /\A[a-zA-Z][a-zA-Z0-9.,-_]{5,31}\Z/
  end

  private

    def ensure_skype_id_format_is_correct
      if skype_id.present?
        unless skype_id =~ SkypeIdHolder.skype_format
          errors.add :skype_id, I18n.t('messages.skype_id_format_is_invalid')
        end
      end
    end
end