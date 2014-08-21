class AddRepresentativeIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :representative_id, :integer
    add_index :organizations, :representative_id
  end
end
