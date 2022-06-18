class CreateSimpleMaths < ActiveRecord::Migration[6.1]
  def change
    Game.find_or_create_by(name: 'Simple Math')
  end
end
