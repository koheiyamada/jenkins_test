class MessageRecipient < ActiveRecord::Base

  class << self
    def of_user(user)
      where(recipient_id: user.id, deleted: false)
    end
  end

  belongs_to :message, counter_cache: true
  belongs_to :recipient, class_name:User.name

  before_create :set_sender_name

  searchable auto_index: false do
    integer :recipient_id
    text :sender_name
    text :title do message.title end
    text :text do message.text end
    boolean :is_read
  end

  def solr_index_for_message_recipient
    Sunspot.index self
    Sunspot.commit
  end

  private

    def set_sender_name
      if message.sender.present?
        self.sender_name = DisplayNameService.new(recipient).name(message.sender)
      else
        self.sender_name = I18n.t('message_recipient.unknown_sender')
      end
    end

    def resolve_sender_name
      DisplayNameService.new(recipient).name(message.sender)
    rescue => e
      logger.error e
      I18n.t('message_recipient.unknown_sender')
    end
end
