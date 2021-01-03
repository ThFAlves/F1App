import UIKit

enum RaceDetailAction {
}

protocol RaceDetailCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: RaceDetailAction)
}

final class RaceDetailCoordinator {
    weak var viewController: UIViewController?

    init() {
    }
}

// MARK: - RaceDetailCoordinating
extension RaceDetailCoordinator: RaceDetailCoordinating {
    func perform(action: RaceDetailAction) {
    }
}
