class AddOrganizationIdToDealBases < ActiveRecord::Migration
  def change
    add_column :deal_bases, :organization_id, :integer
    add_index :deal_bases, :organization_id
  end
end
