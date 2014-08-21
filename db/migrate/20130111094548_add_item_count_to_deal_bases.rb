class AddItemCountToDealBases < ActiveRecord::Migration
  def change
    add_column :deal_bases, :item_count, :integer
  end
end
