import Foundation

protocol PitStopsDataListDisplay {}

struct PitStopsData: Decodable {
    let data: PMPitStopsData
    
    enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

struct PMPitStopsData: Decodable {
    let limit: String
    let offset: String
    let total: String
    let raceTable: RacePitStopsTable
    
    enum CodingKeys: String, CodingKey {
        case total
        case limit
        case offset
        case raceTable = "RaceTable"
    }
}

struct RacePitStopsTable: Decodable {
    let races: [RacePitStops]
    
    enum CodingKeys: String, CodingKey {
        case races = "Races"
    }
}

struct RacePitStops: Decodable, RaceListDisplay {
    let season: String
    let round: String
    let raceName: String
    let pitStopsResult: [PitStopsResults]
    
    enum CodingKeys: String, CodingKey {
        case season
        case round
        case raceName
        case pitStopsResult = "PitStops"
    }
}

struct PitStopsResults: Decodable, DriverResultListDisplay {
    let driverId: String
    let lap: String
    let stop: String
    let time: String
    let duration: String
    
    enum CodingKeys: String, CodingKey {
        case driverId = "driverId"
        case lap
        case stop
        case time
        case duration
    }
}
