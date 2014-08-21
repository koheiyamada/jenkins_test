class CreateCustomOperatingSystems < ActiveRecord::Migration
  def change
    create_table :custom_operating_systems do |t|
      t.references :user_operating_system
      t.string :name

      t.timestamps
    end
    add_index :custom_operating_systems, :user_operating_system_id
  end
end
