class AddRoundIdToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :round, null: false, foreign_key: true
  end
end
