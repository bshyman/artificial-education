class QuestionsController < ApplicationController
  def new_simple_math
    @questions = MultiplicationQuestion.new.generate
  end
end
