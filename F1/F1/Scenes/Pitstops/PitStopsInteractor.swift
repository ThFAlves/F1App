import Foundation

protocol PresenterToInteractorPitStopsProtocol: AnyObject {
    func getPitStops()
}

final class PitStopsInteractor {
    private let service: PitStopsServicing
    private let round: String
    
    weak var presenter: InteractorToPresenterPitStopsProtocol?

    init(service: PitStopsServicing, round: String) {
        self.service = service
        self.round = round
    }
}

// MARK: - PitStopsInteracting
extension PitStopsInteractor: PresenterToInteractorPitStopsProtocol {
    func getPitStops() {
        presenter?.presentStartLoading()
        service.getPitStops(round: "3") { [weak self] result in
            self?.presenter?.presentStopLoading()
            switch result {
            case let .success(model):
                guard let race = model.data.raceTable.races.first else {
                    self?.presenter?.presentError(apiError: .otherErrors)
                    return
                }
                self?.presenter?.displayPitStopsList(list: race.pitStopsResult)
            case let .failure(apiError):
                self?.presenter?.presentError(apiError: apiError)
            }
        }
    }
}
