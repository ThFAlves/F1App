import UIKit

protocol PresenterToViewPitStopsProtocol: AnyObject {
    func displayPitStopsList(list: [PitStopsResults])
    func displayError(apiError: ApiError)
    func startLoading()
    func stopLoading()
}

private extension PitStopsViewController.Layout {
    enum Size {
        static let screenWidth = UIScreen.main.bounds.width
        static let itemHeight: CGFloat = 100
    }
    
    enum Section {
        case main
    }
}

final class PitStopsViewController: ViperViewController<ViewToPresenterPitStopsProtocol, UIView> {
    fileprivate enum Layout { }
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: Layout.Size.screenWidth - 32, height: Layout.Size.itemHeight)
        flowLayout.minimumLineSpacing = 12
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.register(PitStopsCollectionViewCell.self, forCellWithReuseIdentifier: PitStopsCollectionViewCell.identifier)
        return collection
    }()
    
    private lazy var collectionViewDataSource: CollectionViewDataSource<Layout.Section, DriverResultListDisplay> = {
        let dataSource = CollectionViewDataSource<Layout.Section, DriverResultListDisplay>(view: collectionView)
        dataSource.itemProvider = { view, indexPath, item -> UICollectionViewCell? in
            let cell = view.dequeueReusableCell(withReuseIdentifier: PitStopsCollectionViewCell.identifier, for: indexPath) as? PitStopsCollectionViewCell
            cell?.setup(info: item)
            return cell
        }
        dataSource.add(section: .main)
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getPitStops()
    }

    override func buildViewHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureViews() {
        title = "Pit Stops"
        view.backgroundColor = Colors.base
        activityIndicator.color = Colors.white
    }
}

// MARK: - UICollectionViewDelegate
extension PitStopsViewController: UICollectionViewDelegate {
}

// MARK: - PresenterToViewPitStopsProtocol
extension PitStopsViewController: PresenterToViewPitStopsProtocol {
    func displayPitStopsList(list: [PitStopsResults]) {
        collectionView.dataSource = collectionViewDataSource
        collectionViewDataSource.add(items: list, to: .main)
    }
    
    func displayError(apiError: ApiError) {
        let alert = UIAlertController(title: "Ops! Algo deu errado", message: apiError.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Tentar novamente", style: .default) { action in
            self.presenter.getPitStops()
        }
        alert.addAction(action)
        present(alert, animated: true)
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
