class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.references :next_grade

      t.timestamps
    end
    add_index :grades, :next_grade_id
  end
end
