import Foundation

protocol HomeServicing {
    func getCurrentSeason(completion: @escaping CompletionSeasonData)
}

typealias CompletionSeasonData = (Result<SeasonData, ApiError>) -> Void

final class HomeService {
    init() {
    }
}

// MARK: - HomeServicing
extension HomeService: HomeServicing {
    func getCurrentSeason(completion: @escaping CompletionSeasonData) {
        Api<SeasonData>(endpoint: SeasonEndpoint.current).request { [weak self] result in
            DispatchQueue.main.async {
                completion(result.map(\.model))
            }
        }
    }
}
