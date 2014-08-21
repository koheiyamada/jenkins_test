class CreatePaymentVeritransTxns < ActiveRecord::Migration
  def change
    create_table :payment_veritrans_txns do |t|
      t.references :user
      t.string :order_id
      t.string :v_result_code
      t.string :cust_txn
      t.string :march_txn
      t.string :service_type
      t.string :mstatus
      t.string :txn_version
      t.string :card_transactiontype
      t.string :gateway_request_date
      t.string :gateway_response_date
      t.string :center_request_date
      t.string :center_response_date
      t.string :pending
      t.string :loopback
      t.string :connected_center_id
      t.string :amount
      t.string :item_code
      t.string :with_capture
      t.string :return_reference_number
      t.string :auth_code
      t.string :action_code
      t.string :acquirer_code

      t.timestamps
    end
    add_index :payment_veritrans_txns, :user_id
    add_index :payment_veritrans_txns, :order_id
  end
end
