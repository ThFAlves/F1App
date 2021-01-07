import UIKit
import SafariServices

enum RaceDetailAction {
    case open(url: URL)
    case pitStops(round: String)
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
        let view: UIViewController
        switch action {
        case let .open(url):
            view = SFSafariViewController(url: url)
        case let .pitStops(round):
            view = PitStopsRouter.createScene(with: round)
        }
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}
