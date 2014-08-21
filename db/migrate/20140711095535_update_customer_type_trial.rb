class UpdateCustomerTypeTrial < ActiveRecord::Migration
  def change
  	ActiveRecord::Base.connection.execute("update users set customer_type = 'guest' where type = 'TrialStudent' and customer_type is null ")
  end
end
