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
        switch action {
        case let .open(url):
            let view = SFSafariViewController(url: url)
            viewController?.navigationController?.present(view, animated: true)
        case let .pitStops(round):
            let view = PitStopsRouter.createScene(with: round)
            viewController?.navigationController?.pushViewController(view, animated: true)
        }
    }
}
