class PokeapiService
  BASE_URL  = 'http://pokeapi.co/api/v2/pokemon/'


  def fetch_pokemon_by_id(id)
    full_url     = BASE_URL + id.to_s
    raw_response = HTTParty.get(full_url)
    JSON.parse(raw_response.body)
  rescue StandardError => e
    p e
    nil
  end

  def fetch_sprites(id)
    fetch_pokemon_by_id(id)['sprites'].select { |k, v| v.present? }
  end

  def fetch_primary_sprite(id)
    fetch_sprites(id).find { |k, v| k.starts_with?('front') && v.present? }.last
  end

  def pokecount
    response = HTTParty.get(BASE_URL)
    response['count'].to_i
  end

  def import_pokemon
    pokecount.times do |counter|
      next if Pokemon.exists?(pokedex_id: counter)

      response_pokemon = fetch_pokemon_by_id(counter)
      next if response_pokemon.nil?

      pokemon = Pokemon.find_or_initialize_by(pokedex_id: counter)

      pokemon.assign_attributes(
        name: response_pokemon['name'],
        base_experience: response_pokemon['base_experience'],
        image: File.open(Rails.root.join("app/assets/images/pokemon/#{counter}.svg")).read
      )

      next unless pokemon.save

      puts '----------------------------'
      puts "#{pokemon.name.upcase} SAVED"
      puts '----------------------------'
    end
  end
end