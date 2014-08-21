class AddDateOfBecomingTrialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :date_of_becoming_trial, :datetime
  end
end
