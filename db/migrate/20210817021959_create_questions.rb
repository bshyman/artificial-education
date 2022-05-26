class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :content
      t.references :game
      t.references :user
      t.integer :value
      t.string :submitted_answer
      t.text :incorrect_answers, array: true, default: []
      t.string :correct_answer
      t.timestamps
    end
  end
end
