class CollectionsService
  def generate
    result = {}
    response = OpenaiService.new.send_message
    result[:groupings] = response['groupings'].sample(4)
    return generate if result[:groupings].length < 4

    result[:groupings] = response['groupings']
    result[:all_words] = response['groupings'].flat_map { |group| group['words'] }
    result.to_json
  end
end
