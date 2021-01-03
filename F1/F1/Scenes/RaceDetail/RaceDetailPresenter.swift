import Foundation

protocol RaceDetailPresenting: AnyObject {
    var viewController: RaceDetailDisplaying? { get set }
    func didNextStep(action: RaceDetailAction)
}

final class RaceDetailPresenter {
    private let coordinator: RaceDetailCoordinating
    weak var viewController: RaceDetailDisplaying?

    init(coordinator: RaceDetailCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - RaceDetailPresenting
extension RaceDetailPresenter: RaceDetailPresenting {
    func didNextStep(action: RaceDetailAction) {
        coordinator.perform(action: action)
    }
}