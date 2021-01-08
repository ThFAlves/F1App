import Foundation

protocol HomeServicing {
    func getCurrentSeason(completion: @escaping CompletionSeasonData)
}

typealias CompletionSeasonData = (Result<SeasonData, ApiError>) -> Void

// MARK: - HomeServicing
final class HomeService: HomeServicing {
    func getCurrentSeason(completion: @escaping CompletionSeasonData) {
        Api<SeasonData>(endpoint: SeasonEndpoint.current).request { result in
            DispatchQueue.main.async {
                completion(result.map(\.model))
            }
        }
    }
}
