import SnapKit
import UIKit

protocol HomeDisplaying: AnyObject {
    func displayRaceList(races: [Race])
    func displayError(apiError: ApiError)
    func startLoading()
    func stopLoading()
}

private extension HomeViewController.Layout {
    enum Size {
        static let screenWidth = UIScreen.main.bounds.width
        static let itemHeight: CGFloat = 140
        static let offset: CGFloat = 20
    }
    
    enum Section {
        case main
    }
}

final class HomeViewController: ViewController<HomeInteracting, UIView> {
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
        collection.register(RoundCollectionViewCell.self, forCellWithReuseIdentifier: RoundCollectionViewCell.identifier)
        return collection
    }()
    
    private lazy var collectionViewDataSource: CollectionViewDataSource<Layout.Section, RaceListDisplay> = {
        let dataSource = CollectionViewDataSource<Layout.Section, RaceListDisplay>(view: collectionView)
        dataSource.itemProvider = { view, indexPath, item -> UICollectionViewCell? in
            let cell = view.dequeueReusableCell(withReuseIdentifier: RoundCollectionViewCell.identifier, for: indexPath) as? RoundCollectionViewCell
            cell?.setup(info: item)
            return cell
        }
        dataSource.add(section: .main)
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadCurrentSeason()
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
        title = "F1 Challenge"
        view.backgroundColor = Colors.base
        activityIndicator.color = Colors.white
    }
}

// MARK: - HomeDisplaying
extension HomeViewController: HomeDisplaying {
    func displayRaceList(races: [Race]) {
        collectionView.dataSource = collectionViewDataSource
        collectionViewDataSource.add(items: races, to: .main)
    }
    
    func displayError(apiError: ApiError) {
        let alert = UIAlertController(title: "Ops! Algo deu errado", message: apiError.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Tentar novamente", style: .default) { action in
            self.interactor.loadCurrentSeason()
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
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.didSelectItem(row: indexPath.row)
    }
}
