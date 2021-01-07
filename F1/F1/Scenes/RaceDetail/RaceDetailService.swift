import Foundation

protocol RaceDetailServicing {
    func getResult(round: String, completion: @escaping CompletionDriverData)
}

typealias CompletionDriverData = (Result<DriverData, ApiError>) -> Void

final class RaceDetailService: RaceDetailServicing {
    func getResult(round: String, completion: @escaping CompletionDriverData) {
        Api<DriverData>(endpoint: ResultsEndpoint.result(round: round)).request { result in
            DispatchQueue.main.async {
                completion(result.map(\.model))
            }
        }
    }
}
