class CreateStudentSettings < ActiveRecord::Migration
  def change
    create_table :student_settings do |t|
      t.references :student
      t.integer :max_charge, :null => false, :default => 10000
      t.integer :max_extension_charge, :null => false, :default => 0
      t.integer :max_option_charge, :null => false, :default => 0
    end
    add_index :student_settings, :student_id
  end
end
