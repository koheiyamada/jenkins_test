class AddOwnerIdAndOwnerTypeToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :owner_id, :integer
    add_column :answers, :owner_type, :string
    add_index :answers, [:owner_id, :owner_type]

    Answer.all.each do |answer|
      answer.owner = answer.user
      answer.save!
    end
  end
end
