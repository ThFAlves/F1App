import UIKit

enum HomeAction {
    case detail(round: String)
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
        viewController?.navigationController?.pushViewController(RaceDetailFactory.make(round: "8"), animated: true)
    }
}
