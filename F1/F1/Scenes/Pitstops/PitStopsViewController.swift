import UIKit

protocol PresenterToViewPitStopsProtocol: AnyObject {
    func displayError(apiError: ApiError)
    func startLoading()
    func stopLoading()
}

private extension PitStopsViewController.Layout {
    //example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class PitStopsViewController: ViperViewController<ViewToPresenterPitStopsProtocol, UIView> {
    fileprivate enum Layout { }
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getPitStops()
    }

    override func buildViewHierarchy() { }
    
    override func setupConstraints() { }

    override func configureViews() {
        view.backgroundColor = Colors.base
        activityIndicator.color = Colors.white
    }
}

// MARK: - PresenterToViewPitStopsProtocol
extension PitStopsViewController: PresenterToViewPitStopsProtocol {
    func displayError(apiError: ApiError) {
    }
    
    func startLoading() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.removeFromSuperview()
    }
}
