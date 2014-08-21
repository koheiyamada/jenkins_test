class AddIncludesExtensionWageToLessonTutorWages < ActiveRecord::Migration
  def change
    add_column :lesson_tutor_wages, :includes_extension_wage, :boolean, :default => false
  end
end
