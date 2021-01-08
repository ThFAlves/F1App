import UIKit

final class DriverCollectionViewCell: UICollectionViewCell {
    static let identifier = "DriverCollectionViewCell"
    
    private lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = Colors.white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.card
        view.layer.cornerRadius = 16.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "driverBackground")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var constructorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = Colors.secondary
        return label
    }()
    
    private lazy var constructorNationalityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Colors.secondary
        return label
    }()
    
    private lazy var constructorStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(constructorNameLabel)
        stack.addArrangedSubview(constructorNationalityLabel)
        stack.axis = .vertical
        stack.distribution = .equalCentering
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Colors.white
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = Colors.secondary
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(infoLabel)
        stack.addArrangedSubview(constructorStack)
        stack.axis = .vertical
        stack.distribution = .equalCentering
        return stack
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
        positionLabel.text = driver.position
        nameLabel.text = "\(driver.driver.givenName) \(driver.driver.familyName)"
        infoLabel.text = "\(driver.driver.nationality) - \(driver.driver.number)"
        constructorNameLabel.text = driver.constructor.name
        constructorNationalityLabel.text = driver.constructor.nationality
    }
}

// MARK: - ViewConfiguration
extension DriverCollectionViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        infoView.addSubview(backgroundImage)
        infoView.addSubview(stack)
        addSubview(positionLabel)
        addSubview(infoView)
    }
    
    func setupConstraints() {
        positionLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.width.equalTo(80)
        }
        
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        backgroundImage.snp.makeConstraints {
            $0.bottom.top.trailing.equalToSuperview()
            $0.width.equalTo(backgroundImage.snp.height).multipliedBy(1.8)
        }
        infoView.snp.makeConstraints {
            $0.leading.equalTo(positionLabel.snp.trailing)
            $0.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func configureStyles() {
        self.backgroundColor = .clear
    }
}

