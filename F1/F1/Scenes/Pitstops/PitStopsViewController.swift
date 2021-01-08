import UIKit

protocol PresenterToViewPitStopsProtocol: AnyObject {
    func displayPitStopsList(list: [PitStopsResults])
    func displayError(apiError: ApiError)
    func startLoading(hasContent: Bool)
    func stopLoading(hasContent: Bool)
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

    private lazy var lapLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Colors.red
        label.text = "Lap"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stopLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Colors.red
        label.text = "Stop"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lapStopStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(lapLabel)
        stack.addArrangedSubview(stopLabel)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var infoView = UIView()
    
    private lazy var driverLabel: UILabel = {
        let label = UILabel()
        label.text = "Driver"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = Colors.red
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: Layout.Size.screenWidth - 32, height: Layout.Size.itemHeight)
        flowLayout.minimumLineSpacing = 12
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.register(PitStopsCollectionViewCell.self, forCellWithReuseIdentifier: PitStopsCollectionViewCell.identifier)
        return collection
    }()
    
    private lazy var collectionViewDataSource: CollectionViewDataSource<Layout.Section, DriverResultListDisplay> = {
        let dataSource = CollectionViewDataSource<Layout.Section, DriverResultListDisplay>(view: collectionView)
        dataSource.itemProvider = { view, indexPath, item -> UICollectionViewCell? in
            let cell = view.dequeueReusableCell(withReuseIdentifier: PitStopsCollectionViewCell.identifier, for: indexPath) as? PitStopsCollectionViewCell
            cell?.setup(info: item)
            self.presenter.hasMoreItens(indexPath)
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
        infoView.addSubview(lapStopStack)
        infoView.addSubview(driverLabel)
        view.addSubview(infoView)
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        lapStopStack.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.top.bottom.leading.equalToSuperview()
        }
        
        driverLabel.snp.makeConstraints {
            $0.leading.equalTo(lapStopStack.snp.trailing)
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        infoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func configureViews() {
        title = "Pit Stops"
        view.backgroundColor = Colors.base
        activityIndicator.color = Colors.white
        infoView.backgroundColor = Colors.secondaryBase
    }
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
    
    func startLoading(hasContent: Bool) {
        guard !hasContent else { return }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }

    func stopLoading(hasContent: Bool) {
        guard hasContent else { return }
        activityIndicator.removeFromSuperview()
    }
}
