class AddBankToAccessAuthorities < ActiveRecord::Migration
  def change
    add_column :access_authorities, :bank, :integer, :default => 0
  end
end
