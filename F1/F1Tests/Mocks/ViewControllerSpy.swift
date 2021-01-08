import Foundation
import UIKit

final class ViewControllerSpy: UIViewController {
    lazy var didCallPresentViewController = 0
    lazy var presentViewControllerParameter: UIViewController? = nil

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        didCallPresentViewController += 1
        presentViewControllerParameter = viewControllerToPresent
    }
}
