import UIKit

protocol RaceDetailDisplaying: AnyObject {
    func displayDriverResult(driver: [DriverResult])
    func displayTitle(_ titleScreen: String)
    func displayError(apiError: ApiError)
    func startLoading()
    func stopLoading()
}

private extension RaceDetailViewController.Layout {
    enum Size {
        static let screenWidth = UIScreen.main.bounds.width
        static let itemHeight: CGFloat = 140
        static let offset: CGFloat = 20
    }
    
    enum Section {
        case main
    }
}

final class RaceDetailViewController: ViewController<RaceDetailInteracting, UIView> {
    fileprivate enum Layout { }

    private lazy var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: Layout.Size.screenWidth, height: Layout.Size.itemHeight)
        flowLayout.minimumLineSpacing = 12
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.register(DriverCollectionViewCell.self, forCellWithReuseIdentifier: DriverCollectionViewCell.identifier)
        return collection
    }()
    
    private lazy var collectionViewDataSource: CollectionViewDataSource<Layout.Section, DriverResultListDisplay> = {
        let dataSource = CollectionViewDataSource<Layout.Section, DriverResultListDisplay>(view: collectionView)
        dataSource.itemProvider = { view, indexPath, item -> UICollectionViewCell? in
            let cell = view.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.identifier, for: indexPath) as? DriverCollectionViewCell
            cell?.setup(info: item)
            return cell
        }
        dataSource.add(section: .main)
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.getResults()
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
        view.backgroundColor = Colors.base
        activityIndicator.color = Colors.white
    }
}

// MARK: - RaceDetailDisplaying
extension RaceDetailViewController: RaceDetailDisplaying {
    func displayDriverResult(driver: [DriverResult]) {
        collectionView.dataSource = collectionViewDataSource
        collectionViewDataSource.add(items: driver, to: .main)
    }
    
    func displayTitle(_ titleScreen: String) {
        title = titleScreen
    }
    
    func displayError(apiError: ApiError) {
        let alert = UIAlertController(title: "Ops! Algo deu errado", message: apiError.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Tentar novamente", style: .default) { action in
            self.interactor.getResults()
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

// MARK: - UICollectionViewDelegate
extension RaceDetailViewController: UICollectionViewDelegate {
    
}
