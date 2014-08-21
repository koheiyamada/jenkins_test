class AddStatusToMessageRecipient < ActiveRecord::Migration
  def change
	add_column :message_recipients, :is_read, :boolean, null: false, default: false
  end
end
