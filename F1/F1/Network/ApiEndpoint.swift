import Foundation

protocol ApiEndpointExposable {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var body: Data? { get }
    var customHeaders: [String: String] { get }
    var absoluteStringUrl: String { get }
}

extension ApiEndpointExposable {
    var baseURL: URL {
        guard let url = URL(string: Environment.apiUrl.rawValue) else {
            fatalError("You need to define valid url")
        }
        return url
    }

    var absoluteStringUrl: String { "\(baseURL)\(path)" }
    var method: HTTPMethod { .get }
    var parameters: [String: Any] { [:] }
    var body: Data? { nil }
    var customHeaders: [String: String] { [:] }
}
