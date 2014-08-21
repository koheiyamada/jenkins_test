class ReplaceFromAndToOfAvailableTimesWithStartAtAndEndAt < ActiveRecord::Migration
  def up
    add_column :available_times, :start_at, :datetime
    add_column :available_times, :end_at, :datetime

    AvailableTime.all.each do |t|
      t.start_at = t.from
      t.end_at = t.to
      t.save!
    end

    remove_column :available_times, :from
    remove_column :available_times, :to
  end

  def down
    add_column :available_times, :from, :datetime
    add_column :available_times, :to, :datetime

    AvailableTime.all.each do |t|
      t.from = t.start_at
      t.to = t.end_at
      t.save!
    end

    remove_column :available_times, :start_at
    remove_column :available_times, :end_at
  end
end
