class CreateMeetingReports < ActiveRecord::Migration
  def change
    create_table :meeting_reports do |t|
      t.references :meeting
      t.references :author
      t.text :text

      t.timestamps
    end
    add_index :meeting_reports, :meeting_id
    add_index :meeting_reports, :author_id
  end
end
