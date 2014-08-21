class MovePhotos < ActiveRecord::Migration
  def up
    require Rails.root.join 'script/users/move_photos'
  end

  def down
  end
end
