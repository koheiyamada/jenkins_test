class AddExtendedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :extended, :boolean, :default => false
  end
end
