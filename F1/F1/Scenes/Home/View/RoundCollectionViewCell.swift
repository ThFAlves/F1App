import UIKit

final class RoundCollectionViewCell: UICollectionViewCell {
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
    
    func setup(info: RaceListDisplay) {
        guard let race = info as? Race else {
            return
        }
        raceNameLabel.text = race.raceName
    }
}

extension RoundCollectionViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        self.addSubview(raceNameLabel)
    }
    
    func setupConstraints() {
        raceNameLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}
