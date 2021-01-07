import Foundation

typealias CompletionPitStopsData = (Result<PitStopsData, ApiError>) -> Void

protocol PitStopsServicing {
    func getPitStops(round: String, completion: @escaping CompletionPitStopsData)
}

final class PitStopsService {

}

// MARK: - PitStopsServicing
extension PitStopsService: PitStopsServicing {
    func getPitStops(round: String, completion: @escaping CompletionPitStopsData) {
        Api<PitStopsData>(endpoint: PitStopsEndpoint.pitStops(round: round)).request { result in
            DispatchQueue.main.async {
                completion(result.map(\.model))
            }
        }
    }
}
