import SnapKit
import UIKit

protocol RaceListDisplay {}

protocol HomeDisplaying: AnyObject {
    func displayRaceList(races: [Race])
}

private extension HomeViewController.Layout {
    enum Size {
        static let screenWidth = UIScreen.main.bounds.width
        static let itemHeight: CGFloat = 280
        static let offset: CGFloat = 20
    }
    
    enum Section {
        case main
    }
}

final class HomeViewController: ViewController<HomeInteracting, UIView> {
    fileprivate enum Layout { }

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: Layout.Size.screenWidth, height: Layout.Size.itemHeight)
        flowLayout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.register(RoundCollectionViewCell.self, forCellWithReuseIdentifier: "aaa")
        return collection
    }()
    
    private lazy var collectionViewDataSource: CollectionViewDataSource<Layout.Section, RaceListDisplay> = {
        let dataSource = CollectionViewDataSource<Layout.Section, RaceListDisplay>(view: collectionView)
        dataSource.itemProvider = { view, indexPath, item -> UICollectionViewCell? in
            let cell = view.dequeueReusableCell(withReuseIdentifier: "aaa", for: indexPath) as? RoundCollectionViewCell
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
        view.backgroundColor = .white
        
    }
}

// MARK: - HomeDisplaying
extension HomeViewController: HomeDisplaying {
    func displayRaceList(races: [Race]) {
        collectionView.dataSource = collectionViewDataSource
        collectionViewDataSource.add(items: races, to: .main)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.selectRound()
    }
}
