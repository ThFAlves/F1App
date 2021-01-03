import Foundation

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
}
