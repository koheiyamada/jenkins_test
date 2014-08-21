class CreateSubjectLevels < ActiveRecord::Migration
  def change
    create_table :subject_levels do |t|
      t.references :subject
      t.integer :level, :null => false
      t.string :code, :null => false
    end
    add_index :subject_levels, :subject_id
  end
end
