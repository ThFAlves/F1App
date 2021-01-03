import UIKit

final class DriverCollectionViewCell: UICollectionViewCell {
    static let identifier = "DriverCollectionViewCell"
    
    private lazy var raceNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(info: DriverResultListDisplay) {
        guard let driver = info as? DriverResult else {
            return
        }
        raceNameLabel.text = driver.driver.familyName
    }
}

// MARK: - ViewConfiguration
extension DriverCollectionViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        self.addSubview(raceNameLabel)
    }
    
    func setupConstraints() {
        raceNameLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
    func configureStyles() {
        self.backgroundColor = .orange
    }
}

