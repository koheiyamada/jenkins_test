class AddCheckboxesForReasonOfLowEvaluationToCsSheets < ActiveRecord::Migration
  def change
    add_column :cs_sheets, :reason_for_low_score, :string
  end
end
