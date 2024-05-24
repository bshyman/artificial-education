class Game < ApplicationRecord
  has_many :rounds

  all.each do |game|
    define_singleton_method("#{game.name.downcase.gsub(' ', '_')}") do
      find_by(name: game.name)
    end
  end

  def self.pokemon_spellcheck
    @pokemon_spellcheck = Game.find_by(name: 'Pokemon Spellcheck')
  end

  def self.simple_math
    @simple_math = Game.find_by(name: 'Simple Math')
  end

  def self.collections
    @collections = Game.find_by(name: 'Collections')
  end

  def initialize_score_map
    { potential_value: 100, earned_value: 0 }
  end

  def self.start(points)
    Round.create!(game_id: id, potential_value: points)
  end
end

