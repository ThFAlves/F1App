import Foundation

protocol HomeServicing {
    func getCurrentSeason()
}

final class HomeService {
    init() {
    }
}

// MARK: - HomeServicing
extension HomeService: HomeServicing {
    func getCurrentSeason() {
        Api<SeasonData>(endpoint: SeasonEndpoint.current).request { [weak self] result in
            switch result {
            case let .success(model):
                print(model)
            case let .failure(apiError):
                print(apiError)
            }
        }
    }
}
