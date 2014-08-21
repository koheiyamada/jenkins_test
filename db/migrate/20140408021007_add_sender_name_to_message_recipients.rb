class AddSenderNameToMessageRecipients < ActiveRecord::Migration
  def change
    add_column :message_recipients, :sender_name, :string, null: false

    puts <<END
##########################################################################################################
#
# RUN: RAILS_ENV=production bundle exec rails runner db/migration-support/20140408021007_add_sender_name_to_message_recipients.rb
#
##########################################################################################################
END
  end
end
