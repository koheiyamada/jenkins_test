class AddTutorHourlyWageToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :tutor_base_hourly_wage, :integer
    puts <<END
##################################################################
#
# Run this script
#
##################################################################
Lesson.all.find_each{|lesson| lesson.update_column :tutor_base_hourly_wage, lesson.tutor.try(:hourly_wage)}
##################################################################
END
  end
end
