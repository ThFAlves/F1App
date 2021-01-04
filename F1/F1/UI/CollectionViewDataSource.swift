import UIKit

public final class CollectionViewDataSource<Section: Hashable, Item>: ReloadableDataSource<UICollectionView, UICollectionViewCell, Section, Item>, UICollectionViewDataSource {
    // MARK: Aliases
    
    public typealias SupplementaryViewProvider = (_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView?
    
    // MARK: - Providers
    
    public var supplementaryViewProvider: SupplementaryViewProvider?
    
    // MARK: - Collection view data source
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data[sections[section]]?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = self.item(at: indexPath), let cell = itemProvider?(collectionView, indexPath, item) else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        supplementaryViewProvider?(collectionView, kind, indexPath) ?? UICollectionReusableView()
    }
}
