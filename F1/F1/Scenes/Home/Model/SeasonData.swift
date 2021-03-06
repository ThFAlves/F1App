import Foundation

protocol RaceListDisplay {}

struct SeasonData: Decodable {
    let data: MRData
    
    enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

struct MRData: Decodable {
    let total: String
    let raceTable: RaceTable
    
    enum CodingKeys: String, CodingKey {
        case total
        case raceTable = "RaceTable"
    }
}

struct RaceTable: Decodable {
    let races: [Race]
    
    enum CodingKeys: String, CodingKey {
        case races = "Races"
    }
}

struct Race: Decodable, RaceListDisplay {
    let season: String
    let round: String
    let raceName: String
    let circuit: Circuit
    
    enum CodingKeys: String, CodingKey {
        case season
        case round
        case raceName
        case circuit = "Circuit"
    }
}

struct Circuit: Decodable {
    let name: String
    let location: RaceLocation
    
    enum CodingKeys: String, CodingKey {
        case name = "circuitName"
        case location = "Location"
    }
}

struct RaceLocation: Decodable {
    let lat: String
    let long: String
    let locality: String
    let country: String
}
