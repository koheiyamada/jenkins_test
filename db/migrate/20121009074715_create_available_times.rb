class CreateAvailableTimes < ActiveRecord::Migration
  def change
    create_table :available_times, id:false do |t|
      t.references :tutor
      t.datetime :from
      t.datetime :to
    end
    add_index :available_times, :tutor_id
  end
end
