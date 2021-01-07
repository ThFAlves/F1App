import Foundation

final class PitStopsInteractor {
    private let service: PitStopsServicing
    weak var presenter: InteractorToPresenterPitStopsProtocol?

    init(service: PitStopsServicing) {
        self.service = service
    }
}

// MARK: - PitStopsInteracting
extension PitStopsInteractor: PresenterToInteractorPitStopsProtocol {
    func getPitStops() {
        presenter?.presentStartLoading()
        service.getPitStops(round: "3") { [weak self] result in
            switch result {
            case let .success(model):
                print(model)
//                guard let race = model.data.raceTable.races.first else {
//                    self?.presenter.presentError(apiError: .otherErrors)
//                    return
//                }
//                self?.drivers = race.results
//                self?.presenter.presentTitle(race.raceName)
//                self?.presenter.presentDrivers(drivers: race.results)
            case let .failure(apiError):
//                self?.presenter.presentError(apiError: apiError)
            print(apiError)
            }
        }
    }
}
