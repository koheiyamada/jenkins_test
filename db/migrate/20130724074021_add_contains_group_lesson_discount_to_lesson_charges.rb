class AddContainsGroupLessonDiscountToLessonCharges < ActiveRecord::Migration
  def change
    add_column :lesson_charges, :contains_group_lesson_discount, :boolean, :default => false
    add_column :lesson_charges, :contains_extension_fee, :boolean, :default => false
  end
end
