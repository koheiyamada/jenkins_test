class CreateMessageRecipients < ActiveRecord::Migration
  def change
    create_table :message_recipients, id:false do |t|
      t.references :message
      t.references :recipient
    end
    add_index :message_recipients, :message_id
    add_index :message_recipients, :recipient_id
  end
end
