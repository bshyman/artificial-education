# frozen_string_literal: true
class QuestionsController < ApplicationController
  def new_simple_math
    @questions = MultiplicationQuestion.new.generate
  end

  private

  def question_params
    params.require(:question).permit(:content, :correct_answer, :difficulty, :question_type, answers: [])
  end
end
