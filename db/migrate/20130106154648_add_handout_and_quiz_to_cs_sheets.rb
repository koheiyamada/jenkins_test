class AddHandoutAndQuizToCsSheets < ActiveRecord::Migration
  def change
    add_column :cs_sheets, :handout, :boolean, :default => false
    add_column :cs_sheets, :quiz, :boolean, :default => false
  end
end
