class RemoveLessonFeeFromTutorPrices < ActiveRecord::Migration
  def up
    remove_column :tutor_prices, :lesson_fee
  end

  def down
    add_column :tutor_prices, :lesson_fee, :integer
  end
end
