class CreateOperatingSystems < ActiveRecord::Migration
  def change
    create_table :operating_systems do |t|
      t.string :name
      t.boolean :windows_experience_index_score_available, :default => false

      t.timestamps
    end
  end
end
