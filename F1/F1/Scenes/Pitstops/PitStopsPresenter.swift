import Foundation

protocol ViewToPresenterPitStopsProtocol: AnyObject {
    var viewController: PresenterToViewPitStopsProtocol? { get set }
    func getPitStops()
    func hasMoreItens(_ indexPath: IndexPath)
}

protocol InteractorToPresenterPitStopsProtocol: AnyObject {
    func displayPitStopsList(list: [PitStopsResults])
    func presentError(apiError: ApiError)
    func presentStartLoading(hasContent: Bool)
    func presentStopLoading(hasContent: Bool)
}

final class PitStopsPresenter {
    private let interactor: PresenterToInteractorPitStopsProtocol
    private let router: PresenterToRouterPitStopsProtocol
    weak var viewController: PresenterToViewPitStopsProtocol?

    init(interactor: PresenterToInteractorPitStopsProtocol, router: PresenterToRouterPitStopsProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - InteractorToPresenterPitStopsProtocol
extension PitStopsPresenter: InteractorToPresenterPitStopsProtocol {
    func displayPitStopsList(list: [PitStopsResults]) {
        viewController?.displayPitStopsList(list: list)
    }
    
    func presentError(apiError: ApiError) {
        viewController?.displayError(apiError: apiError)
    }

    func presentStartLoading(hasContent: Bool) {
        viewController?.startLoading(hasContent: hasContent)
    }

    func presentStopLoading(hasContent: Bool) {
        viewController?.stopLoading(hasContent: hasContent)
    }
}

// MARK: - ViewToPresenterPitStopsProtocol
extension PitStopsPresenter: ViewToPresenterPitStopsProtocol {
    func getPitStops() {
        interactor.getPitStops(offSet: 0)
    }
    
    func hasMoreItens(_ indexPath: IndexPath) {
        interactor.fetchMoreItensIfNeeded(indexPath)
    }
}
