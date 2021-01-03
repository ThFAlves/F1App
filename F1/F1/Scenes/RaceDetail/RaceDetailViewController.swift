import UIKit

protocol RaceDetailDisplaying: AnyObject {
}

private extension RaceDetailViewController.Layout {
}

final class RaceDetailViewController: ViewController<RaceDetailInteracting, UIView> {
    fileprivate enum Layout { }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.getResults()
    }

    override func buildViewHierarchy() { }
    
    override func setupConstraints() { }

    override func configureViews() {
        view.backgroundColor = .white
    }
}

// MARK: - RaceDetailDisplaying
extension RaceDetailViewController: RaceDetailDisplaying {
}
