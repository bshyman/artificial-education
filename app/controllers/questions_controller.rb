# frozen_string_literal: true
class QuestionsController < ApplicationController
  def new_simple_math
    question = SimpleMathQuestion.all.sample
    render partial: 'rounds/simple_math_question', locals: { question: question }
  end

  private

  def question_params
    params.require(:question).permit(:content, :correct_answer, :difficulty, :question_type, answers: [])
  end
end
