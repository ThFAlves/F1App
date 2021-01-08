import Foundation

protocol RaceDetailInteracting: AnyObject {
    func getResults()
    func didSelectItem(row: Int)
    func openPitStop()
}

final class RaceDetailInteractor {
    private let service: RaceDetailServicing
    private let presenter: RaceDetailPresenting
    
    private let round: String
    var drivers: [DriverResult] = []

    init(round: String, service: RaceDetailServicing, presenter: RaceDetailPresenting) {
        self.service = service
        self.presenter = presenter
        self.round = round
    }
}

// MARK: - RaceDetailInteracting
extension RaceDetailInteractor: RaceDetailInteracting {
    func getResults() {
        presenter.presentStartLoading()
        service.getResult(round: round) { [weak self] result in
            self?.presenter.presentStopLoading()
            switch result {
            case let .success(model):
                guard let race = model.data.raceTable.races.first else {
                    self?.presenter.presentError(apiError: .otherErrors)
                    return
                }
                self?.drivers = race.results
                self?.presenter.presentTitle(race.raceName)
                self?.presenter.presentDrivers(drivers: race.results)
            case let .failure(apiError):
                self?.presenter.presentError(apiError: apiError)
            }
        }
    }
    
    func didSelectItem(row: Int) {
        guard drivers.indices.contains(row), let url = URL(string: drivers[row].driver.url) else {
            return
        }
        presenter.didNextStep(action: .open(url: url))
    }
    
    func openPitStop() {
        presenter.didNextStep(action: .pitStops(round: round))
    }
}
