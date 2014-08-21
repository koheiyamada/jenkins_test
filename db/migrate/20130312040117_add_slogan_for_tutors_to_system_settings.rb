class AddSloganForTutorsToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :slogan_for_tutors, :string
  end
end
