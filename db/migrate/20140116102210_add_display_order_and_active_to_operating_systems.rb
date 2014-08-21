class AddDisplayOrderAndActiveToOperatingSystems < ActiveRecord::Migration
  def change
    add_column :operating_systems, :display_order, :integer, default: 999
    add_column :operating_systems, :active, :boolean, default: true

    puts <<END
################################################
#
# RUN: bundle exec rails runner db/scripts/update_operating_systems.rb
#
################################################
END
  end
end
