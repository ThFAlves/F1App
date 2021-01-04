import UIKit
import SafariServices

enum RaceDetailAction {
    case open(url: URL)
}

protocol RaceDetailCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    func perform(action: RaceDetailAction)
}

final class RaceDetailCoordinator {
    weak var viewController: UIViewController?
}

// MARK: - RaceDetailCoordinating
extension RaceDetailCoordinator: RaceDetailCoordinating {
    func perform(action: RaceDetailAction) {
        if case let .open(url: url) = action {
            let safariViewController = SFSafariViewController(url: url)
            viewController?.navigationController?.present(safariViewController, animated: true)
        }
    }
}
