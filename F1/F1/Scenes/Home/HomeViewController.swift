import UIKit

protocol HomeDisplaying: AnyObject {
}

private extension HomeViewController.Layout {
}

final class HomeViewController: ViewController<HomeInteracting, UIView> {
    fileprivate enum Layout { }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadCurrentSeason()
    }

    override func buildViewHierarchy() { }
    
    override func setupConstraints() { }

    override func configureViews() { }
}

// MARK: - HomeDisplaying
extension HomeViewController: HomeDisplaying {
}
