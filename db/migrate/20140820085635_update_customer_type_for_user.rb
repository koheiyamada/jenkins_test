class UpdateCustomerTypeForUser < ActiveRecord::Migration
  def change
  	ActiveRecord::Base.connection.execute("update users set customer_type = 'premium' where type = 'Student' and customer_type is null ")
  	ActiveRecord::Base.connection.execute("update users set customer_type = 'premium' where type = 'Parent' and customer_type is null ")
  end
end
