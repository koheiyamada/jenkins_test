class CreateDependents < ActiveRecord::Migration
  def change
    create_table :dependents, id:false do |t|
      t.references :parent
      t.references :student
    end
    add_index :dependents, :parent_id
    add_index :dependents, :student_id
  end
end
