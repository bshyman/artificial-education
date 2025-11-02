class AddQuestionContentToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :question_content, :text
  end
end
