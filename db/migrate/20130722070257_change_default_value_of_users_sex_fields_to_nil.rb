class ChangeDefaultValueOfUsersSexFieldsToNil < ActiveRecord::Migration
  def up
    change_column :users, :sex, :string, :default => nil
    change_column :tutor_app_forms, :sex, :string, :default => nil
    change_column :bs_app_forms, :representative_sex, :string, :default => nil
  end

  def down
    change_column :users, :sex, :string, :default => 'male'
    change_column :tutor_app_forms, :sex, :string, :default => 'male'
    change_column :bs_app_forms, :representative_sex, :string, :default => 'male'
  end
end
