class CreateMonthlyStatementUpdateRequests < ActiveRecord::Migration
  def change
    create_table :monthly_statement_update_requests, id: false do |t|
      t.integer :owner_id,  null: false
      t.string :owner_type, null: false
      t.integer :year,      null: false
      t.integer :month,     null: false

      t.timestamps
    end
  end
end
