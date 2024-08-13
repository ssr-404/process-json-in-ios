import Foundation

let json1 = """
[
    {
        "name": "Pokemon Violet",
        "price": 45,
        "description": "Pokémon Violet is one of the two mainline entries in the ninth generation of the Pokémon series, released alongside Pokémon Scarlet. Developed by Game Freak and published by Nintendo and The Pokémon Company, Pokémon Violet was released on November 18, 2022, for the Nintendo Switch."
    },
    {
        "name": "Resident Evil",
        "price": 90
    }
]
""".data(using: .utf8)!


struct Game: Codable {
  var name: String
  var price: Int
  var description: String?
}

let decoder = JSONDecoder()
let games = try decoder.decode([Game].self, from: json1)


print("The following games are available")
for game in games {
  print("\(game.name): \(game.price) points \t")
  if let description = game.description {
    print("\(description)")
  }
}
