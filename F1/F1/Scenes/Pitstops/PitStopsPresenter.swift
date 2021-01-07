import Foundation

protocol ViewToPresenterPitStopsProtocol: AnyObject {
    var viewController: PresenterToViewPitStopsProtocol? { get set }
    func getPitStops()
}

protocol InteractorToPresenterPitStopsProtocol: AnyObject {
    func displayPitStopsList(list: [PitStopsResults])
    func presentError(apiError: ApiError)
    func presentStartLoading()
    func presentStopLoading()
}

//




protocol PresenterToRouterPitStopsProtocol: AnyObject {
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

    func presentStartLoading() {
        viewController?.startLoading()
    }

    func presentStopLoading() {
        viewController?.stopLoading()
    }
}

// MARK: - ViewToPresenterPitStopsProtocol
extension PitStopsPresenter: ViewToPresenterPitStopsProtocol {
    func getPitStops() {
        interactor.getPitStops()
    }
}
