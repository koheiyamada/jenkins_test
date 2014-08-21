class AddDeletedToMessageRecipients < ActiveRecord::Migration
  def change
    add_column :message_recipients, :deleted, :boolean, :default => false
  end
end
