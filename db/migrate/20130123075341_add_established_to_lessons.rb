class AddEstablishedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :established, :boolean, :default => false
  end
end
