class AddOrganizationIdAndContainsBsShareToLessonCharges < ActiveRecord::Migration
  def change
    add_column :lesson_charges, :organization_id, :integer
    add_column :lesson_charges, :contains_bs_share, :boolean

    add_index :lesson_charges, :organization_id
  end
end
