// In Swift, it's common for the property names you use in your code to differ from the corresponding keys in the JSON data. Despite this, you can still adhere to Swift's naming conventions for your properties while working with JSONEncoder and JSONDecoder.
// To map Swift property names to different JSON keys, you use a nested enumeration named CodingKeys within the type that conforms to Codable, Encodable, or Decodable. The CodingKeys enum allows you to specify how each property in your Swift type corresponds to the keys in the JSON. This enum ensures that your code remains clean and follows Swift naming conventions, even when the JSON structure dictates different names. This technique is particularly useful when integrating with APIs where the JSON format is predetermined and cannot be altered to match your preferred Swift

import Foundation

let json2 = """
[
    {
        "game_name": "Pokemon Violet",
        "game_price": 45,
        "description": "Pokémon Violet is one of the two mainline entries in the ninth generation of the Pokémon series, released alongside Pokémon Scarlet. Developed by Game Freak and published by Nintendo and The Pokémon Company, Pokémon Violet was released on November 18, 2022, for the Nintendo Switch."
    },
    {
        "game_name": "Resident Evil",
        "game_price": 90,
        "description": "Resident Evil is a media franchise created by Capcom, which began as a video game series in 1996. The series is set in a world where biological experiments by a pharmaceutical company called Umbrella Corporation lead to the creation of various types of zombies and monsters, setting the stage for horror-themed gameplay and storytelling."
    }
]
""".data(using: .utf8)!

struct Game: Codable {
  var name: String
  var price: Int
  var description: String?

  private enum CodingKeys: String, CodingKey {
      case name = "game_name"
      case price = "game_price"
      case description
  }
}

let decoder = JSONDecoder()
let games = try decoder.decode([Game].self, from: json2)

print("The following games are available: ")
for game in games {
  print("\(game.name): \(game.price) \t")
  if let descipriont = game.description {
    print("\(descipriont) \t")
  }
}
