# Mapper

Heavily based on the [Lyft](https://github.com/lyft/mapper) implementation, this library has been refactored for Swift 5.0 and enables Swift Package.

Mapper is a simple Swift library to convert JSON to strongly typed objects. One advantage to Mapper over some other libraries is you can have immutable properties.


## Installation

**With** [Package Manager](https://swift.org/package-manager/)

```swift
.package(url: "https://github.com/polarcop/mapper.git", .upToNextMajor(from: "1.0.0"))
```


## Usage

### Basic:

```swift
import Mapper
// Conform to the Mappable protocol
struct User: Mappable {
  let id: String
  let photoURL: URL?

  // Implement this initializer
  init(map: Mapper) throws {
    try id = map.from("id")
    photoURL = map.optionalFrom("avatar_url")
  }
}

// Create a user!
let JSON: [String: Any] = ...
let user = User.from(JSON) // This is a 'User?'
```

### With Enums:

```swift
enum UserType: String {
  case Normal = "normal"
  case Admin = "admin"
}

struct User: Mappable {
  let id: String
  let type: UserType

  init(map: Mapper) throws {
    try id = map.from("id")
    try type = map.from("user_type")
  }
}
```


### Nested Mappable objects:

```swift
struct User: Mappable {
  let id: String
  let name: String

  init(map: Mapper) throws {
    try id = map.from("id")
    try name = map.from("name")
  }
}

struct Group: Mappable {
  let id: String
  let users: [User]

  init(map: Mapper) throws {
    try id = map.from("id")
    users = map.optionalFrom("users") ?? []
  }
}
```

### Use Convertible to transparently convert other types from JSON:

```swift
extension CLLocationCoordinate2D: Convertible {
  public static func fromMap(_ value: Any) throws -> CLLocationCoordinate2D {
    guard let location = value as? [String: Any],
      let latitude = location["lat"] as? Double,
      let longitude = location["lng"] as? Double else
      {
         throw MapperError.convertibleError(value: value, type: [String: Double].self)
      }

      return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

struct Place: Mappable {
  let name: String
  let location: CLLocationCoordinate2D

  init(map: Mapper) throws {
    try name = map.from("name")
    try location = map.from("location")
  }
}

let JSON: [String: Any] = [
  "name": "Polar HQ",
  "location": [
    "lat": 51.504949,
    "lng": -0.019501,
  ],
]

let place = Place.from(JSON)
```

### Custom Transformations:

```swift
private func extractFirstName(object: Any?) throws -> String {
  guard let fullName = object as? String else {
    throw MapperError.convertibleError(value: object, type: String.self)
  }

  let parts = fullName.characters.split { $0 == " " }.map(String.init)
  if let firstName = parts.first {
    return firstName
  }

  throw MapperError.customError(field: nil, message: "Couldn't split the string!")
}

struct User: Mappable {
  let firstName: String

  init(map: Mapper) throws {
    try firstName = map.from("name", transformation: extractFirstName)
  }
}
```

### Parse nested or entire objects:
```swift
struct User: Mappable {
  let name: String
  let JSON: AnyObject

  init(map: Mapper) throws {
    // Access the 'first' key nested in a 'name' dictionary
    try name = map.from("name.first")
    // Access the original JSON (maybe for use with a transformation)
    try JSON = map.from("")
  }
}
```
