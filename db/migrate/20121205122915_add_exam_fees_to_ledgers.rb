class AddExamFeesToLedgers < ActiveRecord::Migration
  def change
    add_column :ledgers, :exam2_fee, :integer, :default => 0
    add_column :ledgers, :exam3_fee, :integer, :default => 0
    add_column :ledgers, :exam4_fee, :integer, :default => 0
    add_column :ledgers, :exam5_fee, :integer, :default => 0
  end
end
