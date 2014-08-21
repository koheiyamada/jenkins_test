class RenameBecomingTrialToBecomingFreeOnUsers < ActiveRecord::Migration
  def up
    remove_column :users, :date_of_becoming_trial
    add_column :users, :date_of_becoming_free_user, :datetime
  end
end