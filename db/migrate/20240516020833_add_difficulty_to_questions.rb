class AddDifficultyToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :difficulty, :string
  end
end
