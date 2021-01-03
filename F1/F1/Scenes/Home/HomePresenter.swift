import Foundation

protocol HomePresenting: AnyObject {
    var viewController: HomeDisplaying? { get set }
    func didNextStep(action: HomeAction)
    func displayRaces(races: [Race])
}

final class HomePresenter {
    private let coordinator: HomeCoordinating
    weak var viewController: HomeDisplaying?

    init(coordinator: HomeCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - HomePresenting
extension HomePresenter: HomePresenting {
    func didNextStep(action: HomeAction) {
        coordinator.perform(action: action)
    }
    
    func displayRaces(races: [Race]) {
        viewController?.displayRaceList(races: races)
    }
}
