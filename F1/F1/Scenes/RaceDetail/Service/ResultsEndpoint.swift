import Foundation

enum ResultsEndpoint {
    case result(round: String)
}

extension ResultsEndpoint: ApiEndpoint {
    var path: String {
        switch self {
        case let .result(round):
            return "current/\(round)/results.json"
        }
    }
}
