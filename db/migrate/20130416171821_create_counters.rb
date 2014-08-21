class CreateCounters < ActiveRecord::Migration
  def change
    create_table :counters do |t|
      t.string :key
      t.integer :count, :default => 0

      t.timestamps
    end

    add_index :counters, :key
  end
end
