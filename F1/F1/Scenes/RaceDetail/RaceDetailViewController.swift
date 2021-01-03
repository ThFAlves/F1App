import UIKit

protocol RaceDetailDisplaying: AnyObject {
}

private extension RaceDetailViewController.Layout {
}

final class RaceDetailViewController: ViewController<RaceDetailInteracting, UIView> {
    fileprivate enum Layout { }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func buildViewHierarchy() { }
    
    override func setupConstraints() { }

    override func configureViews() { }
}

// MARK: - RaceDetailDisplaying
extension RaceDetailViewController: RaceDetailDisplaying {
}
