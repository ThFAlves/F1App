import UIKit

final class PitStopsRouter: PresenterToRouterPitStopsProtocol {
    static func createScene(with round: String) -> UIViewController {

        let service: PitStopsServicing = PitStopsService()
        let interactor = PitStopsInteractor(service: service, round: round)
        let presenter: ViewToPresenterPitStopsProtocol & InteractorToPresenterPitStopsProtocol = PitStopsPresenter(interactor: interactor, router: PitStopsRouter())
        let viewController = PitStopsViewController(presenter: presenter)
        
        presenter.viewController = viewController
        interactor.presenter = presenter

        return viewController
    }
}
