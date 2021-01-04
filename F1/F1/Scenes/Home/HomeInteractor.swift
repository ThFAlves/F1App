import Foundation

protocol HomeInteracting: AnyObject {
    func loadCurrentSeason()
    func didSelectItem(row: Int)
}

final class HomeInteractor {
    private let service: HomeServicing
    private let presenter: HomePresenting
    private var races: [Race] = []

    init(service: HomeServicing, presenter: HomePresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - HomeInteracting
extension HomeInteractor: HomeInteracting {
    func loadCurrentSeason() {
        presenter.presentStartLoading()
        service.getCurrentSeason { [weak self] result in
            self?.presenter.presentStopLoading()
            switch result {
            case let .success(seasonList):
                let races = seasonList.data.raceTable.races
                self?.races = races
                self?.presenter.presentRaces(races: races)
            case let .failure(error):
                self?.presenter.presentError(apiError: error)
            }
        }
    }
    
    func didSelectItem(row: Int) {
        guard races.indices.contains(row) else {
            return
        }
        presenter.didNextStep(action: .detail(round: races[row].round))
    }
}
