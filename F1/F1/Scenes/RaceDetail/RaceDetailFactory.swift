import UIKit

enum RaceDetailFactory {
    static func make(round: String) -> RaceDetailViewController {
        let service: RaceDetailServicing = RaceDetailService()
        let coordinator: RaceDetailCoordinating = RaceDetailCoordinator()
        let presenter: RaceDetailPresenting = RaceDetailPresenter(coordinator: coordinator)
        let interactor = RaceDetailInteractor(round: round, service: service, presenter: presenter)
        let viewController = RaceDetailViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
