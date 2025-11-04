class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.references :user
      t.references :question
      t.string :content
      t.boolean :is_correct
      t.integer :value

      t.timestamps
    end
  end
end
