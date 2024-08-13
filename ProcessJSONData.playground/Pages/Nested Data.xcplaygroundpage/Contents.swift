// When developing an app that handles JSON data from external or local sources, you might find that the structure of the JSON data does not align perfectly with the way you want to represent it in your app. Often, data that logically belongs together in your Swift code may be spread across multiple nested objects or arrays in the JSON.

// To address these discrepancies, you can create a custom Decodable type that reflects the structure of the incoming JSON. This intermediate type allows you to safely decode the JSON data and serves as a reliable data source when initializing the types you will use throughout your application.

// By employing these intermediate types, you maintain the flexibility to work with the most intuitive and natural types in your code, while still ensuring compatibility with a variety of JSON structures you might encounter.

import Foundation

struct Dealership {
    var name: String
    var cars: [Car]
    
    struct Car: Codable {
        var name: String
        var price: Int
        var description: String?
    }
}

let json3 = """
[
    {
        "name": "Toyota Columbus",
        "branches": [
            {
                "name": "Toyota Columbus - Germain West",
                "departments": [
                    {
                        "name": "Certified Pre-Owned",
                        "car": {
                            "name": "GR Supra 2021",
                            "price": 42000,
                            "description": "a high-performance sports car developed by Toyota’s Gazoo Racing (GR) division."
                        }
                    }
                ]
            }
        ]
    },
    {
        "name": "Superdeal Auto Group",
        "branches": [
            {
                "name": "Superdeal Auto Group - Irvine",
                "departments": [
                    {
                        "name": "Seasonal Sale",
                        "car": {
                            "name": "Mustang 2018",
                            "price": 32000,
                            "description": "one of the most iconic American sports cars, known for its blend of performance, style, and cultural significance."
                        }
                    },
                    {
                        "name": "Luxury Cars",
                        "car": {
                            "name": "BMW X6 2023",
                            "price": 72000,
                            "description": "a luxury midsize SUV that combines sporty performance with a distinctive, coupe-like design. "
                        }
                    }
                ]
            }
        ]
    }
]
""".data(using: .utf8)!

struct DealerService: Decodable {
  var name: String
  var branches: [Branch]
  
  struct Branch: Decodable {
    var name: String
    var departments: [Department]
    
    struct Department: Decodable {
      var name: String
      var car: Dealership.Car
    }
  }
}

extension Dealership {
  init(from service: DealerService) {
    self.name = service.name
    self.cars = []
    
    for branch in service.branches {
      for department in branch.departments {
        cars.append(department.car)
      }
    }
  }
}

let services = try JSONDecoder().decode([DealerService].self, from: json3)

let dealerships = services.map{ Dealership(from: $0) }

for dealership in dealerships {
  print("\(dealership.name) is selling: ")
  for car in dealership.cars {
    print("\(car.name): &\(car.price)")
    if let description = car.description {
      print(description)
    }
  }
}
