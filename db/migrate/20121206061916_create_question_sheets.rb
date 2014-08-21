class CreateQuestionSheets < ActiveRecord::Migration
  def change
    create_table :question_sheets do |t|
      t.references :exam
      t.string :image

      t.timestamps
    end
    add_index :question_sheets, :exam_id
  end
end
