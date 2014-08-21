class AddGradeGroupOrderToGradeGroups < ActiveRecord::Migration
  def change
    add_column :grade_groups, :grade_group_order, :integer, default: 0, null: false

    puts <<-END
######################################################################################
#
# RUN:
# $ RAILS_ENV=production bundle exec rails runner script/grades/populate_grade_groups.rb
#
######################################################################################
    END
  end
end
