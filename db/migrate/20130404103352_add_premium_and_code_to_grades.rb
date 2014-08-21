class AddPremiumAndCodeToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :code, :string
    add_column :grades, :premium, :integer, :default => 0
    add_column :grades, :special, :boolean, :default => false
  end
end
