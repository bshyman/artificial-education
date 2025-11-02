class PokemonController < ApplicationController
  layout 'pokemon'
  skip_before_action :verify_authenticity_token, only: [:create_round, :submit_answer]

  def index
    @high_scores = Game.pokemon_spellcheck.rounds.where.not(earned_value: [nil, 0]).order(earned_value: :desc).limit(10)
  end

  def new_question
    question = MissingLetterQuestion.new.generate

    partial = render_to_string(partial: 'pokemon_spellcheck_question', locals: {question: question})
    render json: {
      partial: partial,
      question: question
    }, status: :ok
  end

  def create_round
    Rails.logger.info("Creating round for user: #{current_player.id}")

    round = Round.create!(
      game_id: Game.pokemon_spellcheck.id,
      user_id: current_player.id,
      potential_value: 100,
      earned_value: 0
    )

    Rails.logger.info("Round created with id: #{round.id}")
    render json: { round_id: round.id }, status: :created
  rescue StandardError => e
    Rails.logger.error("Error creating round: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  def submit_answer
    Rails.logger.info("Received answer submission with params: #{answer_params.inspect}")

    round = Round.find(answer_params[:round_id])
    Rails.logger.info("Found round: #{round.id}")

    answer = Answer.create!(
      user_id: current_player.id,
      round_id: round.id,
      content: answer_params[:answer],
      is_correct: answer_params[:is_correct],
      value: answer_params[:is_correct] ? 10 : 0,
      question_content: answer_params[:question_content]
    )

    Rails.logger.info("Answer created with id: #{answer.id}")
    render json: { success: true, answer_id: answer.id }, status: :created
  rescue StandardError => e
    Rails.logger.error("Error creating answer: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def answer_params
    params.permit(:round_id, :answer, :is_correct, :question_content)
  end

  def show
  end

  def pokedex
    @pokemon = Pokemon.all.to_json
  end
end
