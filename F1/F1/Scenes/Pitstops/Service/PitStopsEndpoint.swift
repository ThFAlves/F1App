import Foundation

enum PitStopsEndpoint {
    case pitStops(round: String)
}

extension PitStopsEndpoint: ApiEndpoint {
    var path: String {
        switch self {
        case let .pitStops(round):
            return "current/\(round)/pitstops.json"
        }
    }
}
