import Foundation

protocol RaceDetailInteracting: AnyObject {
}

final class RaceDetailInteractor {
    private let service: RaceDetailServicing
    private let presenter: RaceDetailPresenting

    init(service: RaceDetailServicing, presenter: RaceDetailPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - RaceDetailInteracting
extension RaceDetailInteractor: RaceDetailInteracting {
}
