class AddKanaToTutorAppForms < ActiveRecord::Migration
  def change
    add_column :tutor_app_forms, :first_name_kana, :string
    add_column :tutor_app_forms, :last_name_kana, :string
  end
end
