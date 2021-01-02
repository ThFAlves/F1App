import Foundation

enum SeasonEndpoint {
    case current
}

extension SeasonEndpoint: ApiEndpoint {
    var path: String {
        "current.json"
    }
}
