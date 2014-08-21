class AddAccountingStatusToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :accounting_status, :string, :default => 'unprocessed'
  end
end
