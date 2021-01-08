import Foundation

enum PitStopsEndpoint {
    case pitStops(round: String, offSet: Int)
}

extension PitStopsEndpoint: ApiEndpoint {
    var path: String {
        switch self {
        case let .pitStops(round, offSet):
            return "current/\(round)/pitstops.json?limit=10&offset=\(offSet)"
        }
    }
}
