class AddOrderToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :grade_order, :integer
    puts '###'
    puts '### Run db/seeds/grades.rb'
    puts '###'
  end
end
