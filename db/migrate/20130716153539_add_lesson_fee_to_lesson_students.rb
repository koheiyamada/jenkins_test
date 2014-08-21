class AddLessonFeeToLessonStudents < ActiveRecord::Migration
  def change
    add_column :lesson_students, :base_lesson_fee_per_unit, :integer

    puts <<-END
    #########################################################################
    #
    # RUN script/lesson_students/reset_lesson_fee.rb
    #
    #########################################################################
    END
  end
end
