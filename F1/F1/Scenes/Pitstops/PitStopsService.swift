import Foundation

protocol PitStopsServicing {
    func getPitStops(round: String, completion: @escaping CompletionDriverData)
}

final class PitStopsService {

}

// MARK: - PitStopsServicing
extension PitStopsService: PitStopsServicing {
    func getPitStops(round: String, completion: @escaping CompletionDriverData) {
        Api<DriverData>(endpoint: ResultsEndpoint.result(round: round)).request { result in
            DispatchQueue.main.async {
                completion(result.map(\.model))
            }
        }
    }
}
