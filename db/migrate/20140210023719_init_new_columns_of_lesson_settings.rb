class InitNewColumnsOfLessonSettings < ActiveRecord::Migration
  def up
    puts <<-END
###########################################################
#  RUN:
#  system_settings = SystemSettings.instance
#  lesson_settings = LessonSettings.instance
#  lesson_settings.update_attributes!(
#  request_time_limit: system_settings.lesson_request_time_limit,
#  max_units: system_settings.max_lesson_units,
#  max_units_of_basic_lesson: system_settings.max_basic_lesson_units,
#  message_to_tutor: system_settings.slogan_for_tutors
#
###########################################################
    END
  end

  def down
  end
end
