import Foundation

protocol DriverResultListDisplay {}

struct DriverData: Decodable {
    let data: MRDriverData
    
    enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

struct MRDriverData: Decodable {
    let total: String
    let raceTable: RaceDriverTable
    
    enum CodingKeys: String, CodingKey {
        case total
        case raceTable = "RaceTable"
    }
}

struct RaceDriverTable: Decodable {
    let races: [RaceDriver]
    
    enum CodingKeys: String, CodingKey {
        case races = "Races"
    }
}

struct RaceDriver: Decodable, RaceListDisplay {
    let season: String
    let round: String
    let raceName: String
    let results: [DriverResult]
    
    enum CodingKeys: String, CodingKey {
        case season
        case round
        case raceName
        case results = "Results"
    }
}

struct DriverResult: Decodable, DriverResultListDisplay {
    let number: String
    let position: String
    let points: String
    let driver: Driver
    let constructor: Constructor
    
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case position = "position"
        case points = "points"
        case driver = "Driver"
        case constructor = "Constructor"
    }
}

struct Driver: Codable {
    let number: String
    let code: String
    let url: String
    let givenName: String
    let familyName: String
    let nationality: String
    
    enum CodingKeys: String, CodingKey {
        case number = "permanentNumber"
        case code
        case url
        case givenName = "givenName"
        case familyName = "familyName"
        case nationality
    }
}

struct Constructor: Decodable {
    let url: String
    let name: String
    let nationality: String
}
