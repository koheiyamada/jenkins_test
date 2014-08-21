class AddAbortedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :aborted, :boolean, default:false
  end
end
