import UIKit

//enum PitStopsFactory {
//    static func make() -> PitStopsViewController {
//        let service: PitStopsServicing = PitStopsService(dependencies: container)
//        let coordinator: PitStopsCoordinating = PitStopsCoordinator(dependencies: container)
//        let presenter: PitStopsPresenting = PitStopsPresenter(coordinator: coordinator, dependencies: container)
//        let interactor = PitStopsInteractor(service: service, presenter: presenter, dependencies: container)
//        let viewController = PitStopsViewController(interactor: interactor)
//
//        coordinator.viewController = viewController
//        presenter.viewController = viewController
//
//        return viewController
//    }
//}

protocol InteractorToPresenterPitStopsProtocol: AnyObject {
    
}

final class PitStopsRouter: PresenterToRouterPitStopsProtocol {
    static func createScene(with round: String) -> UIViewController {

        let service: PitStopsServicing = PitStopsService()
        
        let interactor = PitStopsInteractor(service: service)
        
        let presenter: ViewToPresenterPitStopsProtocol & InteractorToPresenterPitStopsProtocol = PitStopsPresenter(interactor: interactor, router: PitStopsRouter())

        let viewController = PitStopsViewController(presenter: presenter)
        presenter.viewController = viewController

        return viewController
    }
}
