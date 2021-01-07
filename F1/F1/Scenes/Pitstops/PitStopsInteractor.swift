import Foundation

protocol PresenterToInteractorPitStopsProtocol: AnyObject {
    func getPitStops(offSet: Int)
    func fetchMoreItensIfNeeded(_ indexPath: IndexPath)
}

final class PitStopsInteractor {
    private let service: PitStopsServicing
    private let round: String
    
    weak var presenter: InteractorToPresenterPitStopsProtocol?

    private var hasContent: Bool {
        !pitStopsResult.isEmpty
    }
    
    private var hasRequest = false
    private var page: Page?
    
    private var pitStopsResult: [PitStopsResults] = []
    
    init(service: PitStopsServicing, round: String) {
        self.service = service
        self.round = round
    }
    
    private func getNextOffSet() -> Int? {
        guard !hasRequest, let page = page, (page.limit + page.offset < page.total) else {
            return nil
        }
        return page.limit + page.offset
    }
}

// MARK: - PitStopsInteracting
extension PitStopsInteractor: PresenterToInteractorPitStopsProtocol {
    func fetchMoreItensIfNeeded(_ indexPath: IndexPath) {
        guard indexPath.row == (pitStopsResult.count - 1), let offSet = getNextOffSet() else { return }
        getPitStops(offSet: offSet)
    }
    
    func getPitStops(offSet: Int) {
        presenter?.presentStartLoading(hasContent: hasContent)
        hasRequest = true
        service.getPitStops(round: round, offSet: offSet) { [weak self] result in
            guard let self = self else { return }
            self.hasRequest = false
            switch result {
            case let .success(model):
                guard let race = model.data.raceTable.races.first else {
                    self.presenter?.presentError(apiError: .otherErrors)
                    return
                }
                self.page = Page(pitStopData: model.data)
                self.pitStopsResult.append(contentsOf: race.pitStopsResult)
                self.presenter?.presentStopLoading(hasContent: self.hasContent)
                self.presenter?.displayPitStopsList(list: race.pitStopsResult)
            case let .failure(apiError):
                self.presenter?.presentStopLoading(hasContent: self.hasContent)
                self.presenter?.presentError(apiError: apiError)
            }
        }
    }
}
