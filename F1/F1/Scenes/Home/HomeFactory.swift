import UIKit

enum HomeFactory {
    static func make() -> HomeViewController {
        let service: HomeServicing = HomeService()
        let coordinator: HomeCoordinating = HomeCoordinator()
        let presenter: HomePresenting = HomePresenter(coordinator: coordinator)
        let interactor = HomeInteractor(service: service, presenter: presenter)
        let viewController = HomeViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
