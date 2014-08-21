class CreateUnavailableDays < ActiveRecord::Migration
  def change
    create_table :unavailable_days do |t|
      t.references :tutor
      t.date :date
    end
    add_index :unavailable_days, :tutor_id
  end
end
