import Foundation

protocol HomeInteracting: AnyObject {
    func loadCurrentSeason()
}

final class HomeInteractor {
    private let service: HomeServicing
    private let presenter: HomePresenting

    init(service: HomeServicing, presenter: HomePresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - HomeInteracting
extension HomeInteractor: HomeInteracting {
    func loadCurrentSeason() {
        service.getCurrentSeason()
    }
}
