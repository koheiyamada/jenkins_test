class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :code
      t.string :name

      t.timestamps
    end

    YAML.load_file(Rails.root.join('db', 'data', 'banks.yml')).each do |attr|
      Bank.create! attr
    end
  end
end
