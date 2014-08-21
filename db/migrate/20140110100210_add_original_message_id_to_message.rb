class AddOriginalMessageIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :original_message_id, :integer
  end
end
