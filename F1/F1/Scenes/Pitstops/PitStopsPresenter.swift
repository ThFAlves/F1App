import Foundation

protocol ViewToPresenterPitStopsProtocol: AnyObject {
    var viewController: PresenterToViewPitStopsProtocol? { get set }
    func didLoad()
}

//


protocol PresenterToInteractorPitStopsProtocol: AnyObject {
    
}

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
}

// MARK: - ViewToPresenterPitStopsProtocol
extension PitStopsPresenter: ViewToPresenterPitStopsProtocol {
    func didLoad() {
        // ate ate ta certo
    }
}
