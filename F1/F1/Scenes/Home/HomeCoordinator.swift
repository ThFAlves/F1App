import UIKit

enum HomeAction {
}

protocol HomeCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: HomeAction)
}

final class HomeCoordinator {
    weak var viewController: UIViewController?

    init() {
    }
}

// MARK: - HomeCoordinating
extension HomeCoordinator: HomeCoordinating {
    func perform(action: HomeAction) {
    }
}
