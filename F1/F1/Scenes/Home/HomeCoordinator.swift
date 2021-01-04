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
}

// MARK: - HomeCoordinating
extension HomeCoordinator: HomeCoordinating {
    func perform(action: HomeAction) {
        if case let .detail(round) = action {
            viewController?.navigationController?.pushViewController(RaceDetailFactory.make(round: round), animated: true)
        }
    }
}
