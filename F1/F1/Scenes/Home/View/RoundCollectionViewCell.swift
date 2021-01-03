import UIKit

final class RoundCollectionViewCell: UICollectionViewCell {
    static let identifier = "RoundCollectionViewCell"
    
    private lazy var localityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private lazy var circuitStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(localityLabel)
        stack.addArrangedSubview(locationLabel)
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var raceNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    private lazy var circuitNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(raceNameLabel)
        stack.addArrangedSubview(circuitNameLabel)
        stack.addArrangedSubview(circuitStack)
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
    
    func setup(info: RaceListDisplay) {
        guard let race = info as? Race else {
            return
        }
        raceNameLabel.text = race.raceName
        circuitNameLabel.text = race.circuit.name
        localityLabel.text = "\(race.circuit.location.locality) \(race.circuit.location.country)"
        locationLabel.text = "Lat:\(race.circuit.location.lat) Lon:\(race.circuit.location.long)"
    }
}

extension RoundCollectionViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(stack)
    }
    
    func setupConstraints() {
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    func configureViews() {
        layer.cornerRadius = 16.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true
    }
    
    func configureStyles() {
        backgroundColor = Colors.card
    }
}
