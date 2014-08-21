class RemoveRedundantColumnsFromTutorInfos < ActiveRecord::Migration
  def up
    remove_column :tutor_infos, :first_name
    remove_column :tutor_infos, :last_name
    remove_column :tutor_infos, :phone_number
    remove_column :tutor_infos, :skype_id
    remove_column :tutor_infos, :nickname
    remove_column :tutor_infos, :confirmed
  end

  def down
    add_column :tutor_infos, :first_name, :string
    add_column :tutor_infos, :last_name, :string
    add_column :tutor_infos, :phone_number, :string
    add_column :tutor_infos, :skype_id, :string
    add_column :tutor_infos, :nickname, :string
    add_column :tutor_infos, :confirmed, :boolean, :default => false
  end
end
