class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :pokedex_id
      t.integer :base_experience
      t.string :image

      t.timestamps
    end
  end
end
