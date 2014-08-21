class AddLessonFeesToTutorPrices < ActiveRecord::Migration
  def change
    add_column :tutor_prices, :lesson_fee_0, :integer
    add_column :tutor_prices, :lesson_fee_50, :integer
    add_column :tutor_prices, :lesson_fee_100, :integer
    add_column :tutor_prices, :lesson_fee_200, :integer

    Tutor.all.each do |tutor|
      tutor.price.reset_lesson_fee_table
    end
    SpecialTutor.all.each do |tutor|
      tutor.price.reset_lesson_fee_table
    end
  end
end
