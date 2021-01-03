import Foundation

protocol RaceDetailInteracting: AnyObject {
    func getResults()
}

final class RaceDetailInteractor {
    private let service: RaceDetailServicing
    private let presenter: RaceDetailPresenting
    
    private let round: String

    init(round: String, service: RaceDetailServicing, presenter: RaceDetailPresenting) {
        self.service = service
        self.presenter = presenter
        self.round = round
    }
}

// MARK: - RaceDetailInteracting
extension RaceDetailInteractor: RaceDetailInteracting {
    func getResults() {
        service.getResult(round: round) { [weak self] result in
            switch result {
            case let .success(model):
                let drivers = model.data.raceTable.races.first?.results ?? []
                self?.presenter.presentDrivers(drivers: drivers)
            case let .failure(apiError):
                print(apiError)
            }
        }
    }
}
