import Foundation

protocol RaceDetailServicing {
    func getResult(round: String, completion: @escaping CompletionSeasonData)
}

final class RaceDetailService {
    init() {
    }
}

// MARK: - RaceDetailServicing
extension RaceDetailService: RaceDetailServicing {
    func getResult(round: String, completion: @escaping CompletionSeasonData) {
        Api<SeasonData>(endpoint: ResultsEndpoint.result(round: round)).request { [weak self] result in
            DispatchQueue.main.async {
                completion(result.map(\.model))
            }
        }
    }
}
