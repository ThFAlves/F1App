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
    
    private lazy var infoView = UIView()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Results"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = Colors.red
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: Layout.Size.screenWidth, height: Layout.Size.itemHeight)
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "pitStopIcon"),
            style: .plain,
            target: self,
            action: #selector(openPitStop)
        )
    }

    override func buildViewHierarchy() {
        infoView.addSubview(descriptionLabel)
        view.addSubview(infoView)
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        infoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func configureViews() {
        view.backgroundColor = Colors.base
        activityIndicator.color = Colors.white
        infoView.backgroundColor = Colors.secondaryBase
    }
    
    @objc
    func openPitStop() {
        interactor.openPitStop()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.didSelectItem(row: indexPath.row)
    }
}
