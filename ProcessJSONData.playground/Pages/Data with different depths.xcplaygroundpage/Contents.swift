// Sometimes, the data model provided by a JSON file or API may not align perfectly with the model you’re using in your app. In these cases, it may be necessary to merge or split JSON objects during the encoding and decoding processes. This often requires accessing various levels within the JSON object’s hierarchy to accurately map the data.

// The example below demonstrates a common situation where such data merging is needed. It involves modeling a course list that tracks information such as the name, price, and other relevant details for each product it sells.

import Foundation

let json = """
{
    "Intro to Network Security": {
        "credits": 4,
        "description": "Introduction to cybersecurity and digital authentication."
    },
    "Mobile Application - Android": {
        "credits": 3
    }
}
""".data(using: .utf8)!

struct CourseList {
  var courses: [Course]
  
  struct Course {
    var name: String
    var credits: Int
    var description: String?
  }
}

extension CourseList: Encodable {
  
  struct CustomKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
      self.stringValue = stringValue
    }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
    
    static let credits = CustomKey(stringValue: "credits")!
    static let description = CustomKey(stringValue: "description")!
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CustomKey.self)
    
    for course in courses {
      // Any course's `name` can be used as a key name.
      let nameKey = CustomKey(stringValue: course.name)!
      var courseContainer = container.nestedContainer(keyedBy: CustomKey.self, forKey: nameKey)
      
      // The rest of the keys use static names defined in `CustomKey`.
      try courseContainer.encode(course.credits, forKey: .credits)
      try courseContainer.encode(course.description, forKey: .description)
    }
  }
}

var encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let courseList = CourseList(courses: [
  .init(name: "Intro to Network Security", credits: 4, description: "Introduction to cybersecurity and digital authentication."),
  .init(name: "Mobile Application - Android", credits: 3)
])

print("The result of encoding a CourseList:")
let encodedCourses = try encoder.encode(courseList)
print(String(data: encodedCourses, encoding: .utf8)!)
print()

extension CourseList: Decodable {
  public init(from decoder: Decoder) throws {
    var courses = [Course]()
    let container = try decoder.container(keyedBy: CustomKey.self)
    for key in container.allKeys {
      // Note how the `key` in the loop above is used immediately to access a nested container.
      let courseContainer = try container.nestedContainer(keyedBy: CustomKey.self, forKey: key)
      let credits = try courseContainer.decode(Int.self, forKey: .credits)
      let description = try courseContainer.decodeIfPresent(String.self, forKey: .description)
      
      // The key is used again here and completes the collapse of the nesting that existed in the JSON representation.
      let course = Course(name: key.stringValue, credits: credits, description: description)
      courses.append(course)
    }
    
    self.init(courses: courses)
  }
}

let decoder = JSONDecoder()
let decodedCourseList = try decoder.decode(CourseList.self, from: json)

print("The University is opening the following courses:")
for course in decodedCourseList.courses {
  print("\t\(course.name) (\(course.credits) credits)")
  if let description = course.description {
    print("\t\t\(description)")
  }
}
