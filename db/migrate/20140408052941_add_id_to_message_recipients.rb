class AddIdToMessageRecipients < ActiveRecord::Migration
  def change
    add_column :message_recipients, :id, :primary_key
  end
end
