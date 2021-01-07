import Foundation

typealias CompletionPitStopsData = (Result<PitStopsData, ApiError>) -> Void

protocol PitStopsServicing {
    func getPitStops(round: String, offSet: Int, completion: @escaping CompletionPitStopsData)
}

// MARK: - PitStopsServicing
final class PitStopsService: PitStopsServicing {
    func getPitStops(round: String, offSet: Int, completion: @escaping CompletionPitStopsData) {
        Api<PitStopsData>(endpoint: PitStopsEndpoint.pitStops(round: round, offSet: offSet)).request { result in
            DispatchQueue.main.async {
                completion(result.map(\.model))
            }
        }
    }
}
