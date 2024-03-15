module ApplicationHelper
  QUESTIONABLE_TYPES = %w[simple_math TriviaQuestion connections].freeze

  def questionable_types_for_select
    QUESTIONABLE_TYPES.map { |type| [type.titleize, type] }
  end

  def difficulty_options
    Question::VALID_DIFFICULTIES
  end
end
