class AddLastRequestAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_request_at, :datetime
    puts '########################################################################'
    puts '#'
    puts '# RUN THIS CODE:'
    puts '#'
    puts '# Tutor.where(last_request_at:nil).each{|t| t.update_column :last_request_at, t.current_sign_in_at}'
    puts '#'
    puts '########################################################################'
  end
end
