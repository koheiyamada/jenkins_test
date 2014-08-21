class CreateGradeGroups < ActiveRecord::Migration
  def change
    create_table :grade_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
