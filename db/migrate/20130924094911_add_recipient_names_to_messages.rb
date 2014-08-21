class AddRecipientNamesToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :recipient_names, :string
    add_column :messages, :recipient_names_for_hq_user, :string
    add_column :messages, :recipient_names_for_bs_user, :string
    add_column :messages, :recipient_names_for_coach, :string
    add_column :messages, :recipient_names_for_tutor, :string
    add_column :messages, :recipient_names_for_student, :string
    add_column :messages, :recipient_names_for_parent, :string

    puts <<-END
######################################################
#
# RUN: script/messages/reset_recipient_names.rb
#
######################################################
    END
  end
end
