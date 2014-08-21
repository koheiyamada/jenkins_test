class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.references :creator
      t.datetime :datetime

      t.timestamps
    end
    add_index :meetings, :creator_id
  end
end
