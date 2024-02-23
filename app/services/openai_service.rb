class OpenaiService
  def initialize
    @client = OpenAI::Client.new(access_token: Rails.application.credentials.openai[:api_key])
  end

  def send_message
    text = <<~MSG
            I'm developing a children's game application inspired by the New York Times' "Connections," using the Ruby on Rails framework with the ruby-openai client. My aim is for the OpenAI API to generate creative and varied groupings of related words suitable for children, with each grouping accompanied by a descriptive answer key indicating their connection. These connections should be imaginative and extend beyond simple categories to include grammatical, contextual, or thematic relationships. For inspiration, here are example groups I've provided:

            Group 1: graze, nibble, snack, peck. Answer: "eat a little."
            Group 2: beans, pasta, stock, vegetables. Answer: "ingredients in minestrone."
            Group 3: hunt, stalk, track, trail. Answer: "pursue."
            Group 4: broad, fore, pod, type. Answer: "cast" (as in broadcast, forecast, podcast, typecast).

            Here is another example -#{' '}
            group 1: frame, door, handle, lock - parts of a door
            group 2:  log, kindling, tinder, match - used in. building a fire
            group 3: drill, grinder, router, saw - tools
            group 4: blow, bumble, fluff, spoil - mess up

            you should not use these examples, they should only serve as inspiration for the type of groupings I'm looking for.

            The API response should be structured in a JSON format as follows:
            json code structure example:
            {
              "groupings": [
                {
                  "words": ["word1", "word2", "word3", "word4"],
                  "commonality": "string describing the connection",
                  "additional_information": "string providing rationale or educational content",
                  "difficulty": "rate the difficulty of the grouping from 1 to 4 relative to the other groupings, ensuring no duplicates of the same difficulty level."
                },
                ... // Repeat for each grouping
              ]
            }
            This format will ensure the response is straightforward to integrate into my application, providing a scalable challenge that caters to various ages and cognitive abilities.
      return me a JSON response with the groupings and their answers
    MSG

    response = @client.chat(
      parameters: {
        model: 'gpt-3.5-turbo', # Required.
        messages: [{ role: 'user', content: text }], # Required.
        temperature: 1
      })
    JSON.parse(response.dig('choices', 0, 'message', 'content'))
  end
end
