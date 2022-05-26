class CreateRounds < ActiveRecord::Migration[6.1]
  def change
    create_table :rounds do |t|
      t.references :game
      t.references :user
      t.integer :potential_value
      t.integer :earned_value
      t.integer :current_question_id
      t.timestamps
    end
  end
end
