class UpdateCustomerType < ActiveRecord::Migration
  def change
  	ActiveRecord::Base.connection.execute("update users set customer_type = 'premium' where (type = 'Student' or type = 'Parent') and customer_type is null ")
  end
end
