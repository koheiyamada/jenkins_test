class AddLeftAtToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :left_at, :datetime
  end
end
