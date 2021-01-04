import Foundation

protocol HomePresenting: AnyObject {
    var viewController: HomeDisplaying? { get set }
    func didNextStep(action: HomeAction)
    func presentRaces(races: [Race])
    func presentStartLoading()
    func presentStopLoading()
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
    
    func presentRaces(races: [Race]) {
        viewController?.displayRaceList(races: races)
    }
    
    func presentStartLoading() {
        viewController?.startLoading()
    }
    
    func presentStopLoading() {
        viewController?.stopLoading()
    }
}
