class AddBsToAccessAuthorities < ActiveRecord::Migration
  def change
    add_column :access_authorities, :bs, :integer, :default => 0
  end
end
