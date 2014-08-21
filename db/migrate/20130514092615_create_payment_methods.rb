class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.references :user
      t.string :type

      t.timestamps
    end
    add_index :payment_methods, :user_id
  end
end
