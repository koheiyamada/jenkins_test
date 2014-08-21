class AddMessageRecipientsCountToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :message_recipients_count, :integer, null: false, default: 0

    Message.find_each do |m|
      Message.reset_counters m.id, :message_recipients
    end
  end
end
