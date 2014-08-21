class AddConfirmedAtToTutorAppForms < ActiveRecord::Migration
  def change
    add_column :tutor_app_forms, :confirmed_at, :datetime
  end
end
