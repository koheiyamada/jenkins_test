class AddFavoriteBooksToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :favorite_books, :string, :limit => 1000
  end
end
