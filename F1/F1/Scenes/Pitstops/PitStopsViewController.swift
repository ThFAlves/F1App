import UIKit

protocol PresenterToViewPitStopsProtocol: AnyObject {
    func presentView()
}

private extension PitStopsViewController.Layout {
    //example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class PitStopsViewController: ViperViewController<ViewToPresenterPitStopsProtocol, UIView> {
    fileprivate enum Layout { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad()
    }

    override func buildViewHierarchy() { }
    
    override func setupConstraints() { }

    override func configureViews() {
        view.backgroundColor = Colors.base
    }
}

// MARK: - PresenterToViewPitStopsProtocol
extension PitStopsViewController: PresenterToViewPitStopsProtocol {
    func presentView() {
    }
}
