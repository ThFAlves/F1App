import Foundation

final class PitStopsInteractor {
    private let service: PitStopsServicing

    init(service: PitStopsServicing) {
        self.service = service
    }
}

// MARK: - PitStopsInteracting
extension PitStopsInteractor: PresenterToInteractorPitStopsProtocol {
}
