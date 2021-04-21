import Foundation

public struct SwapiPerson : Codable {
    
    public let birthYear: String
    public let eyeColor: String
    public let films: [String]
    public let gender: String
    public let hairColor: String
    public let height: String
    public let homeWorld: String
    public let mass: String
    public let skinColor: String
    public let created: Date
    public let edited: Date
    public let species: [String]
    public let starships: [String]
    public let url: String
    public let vehicles: [String]
    
    enum CodingKeys: String, CodingKey {
        case birthYear = "birth_year"
        case eyeColor = "eye_color"
        case films
        case gender
        case hairColor = "hair_color"
        case height
        case homeWorld = "homeworld"
        case mass
        case skinColor = "skin_color"
        case created
        case edited
        case species
        case starships
        case url
        case vehicles
    }
    
}
