class AddStatusToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :status, :string, :default => 'new'
  end
end
