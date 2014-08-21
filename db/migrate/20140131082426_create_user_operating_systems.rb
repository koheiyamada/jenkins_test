class CreateUserOperatingSystems < ActiveRecord::Migration
  def change
    create_table :user_operating_systems do |t|
      t.references :user
      t.references :operating_system

      t.timestamps
    end
    add_index :user_operating_systems, :user_id
    add_index :user_operating_systems, :operating_system_id
  end
end
