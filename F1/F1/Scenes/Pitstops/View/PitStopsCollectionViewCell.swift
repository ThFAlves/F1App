import UIKit

final class PitStopsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PitStopsCollectionViewCell"
    
    private lazy var lapLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Colors.white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stopLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Colors.white
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
        let image = UIImage(named: "pitstopBackground")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var driverNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Colors.white
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Colors.secondary
        return label
    }()
    
    private lazy var pitStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(driverNameLabel)
        stack.addArrangedSubview(timeLabel)
        stack.axis = .vertical
        stack.distribution = .fill
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
        guard let pitStop = info as? PitStopsResults else {
            return
        }
        lapLabel.text = pitStop.lap
        stopLabel.text = pitStop.stop
        timeLabel.text = "Time: \(pitStop.time) - Duration: \(pitStop.duration)"
        driverNameLabel.text = pitStop.driverId.capitalized
    }
}

// MARK: - ViewConfiguration
extension PitStopsCollectionViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        infoView.addSubview(backgroundImage)
        infoView.addSubview(pitStack)
        addSubview(lapStopStack)
        addSubview(infoView)
    }
    
    func setupConstraints() {
        lapStopStack.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(infoView.snp.leading)
        }

        backgroundImage.snp.makeConstraints {
            $0.bottom.top.trailing.equalToSuperview()
            $0.width.equalTo(backgroundImage.snp.height).multipliedBy(1.8)
        }
        
        pitStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        infoView.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func configureStyles() {
        self.backgroundColor = .clear
    }
}
