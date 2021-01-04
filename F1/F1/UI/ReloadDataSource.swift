import Foundation

public class ReloadableDataSource<View: AnyObject & ReloadableView, Cell, Section: Hashable, Item>: NSObject, Reloadable {
    public weak var reloadableView: View?
    public var automaticReloadData = true
    
    // MARK: Aliases
    
    public typealias ItemProvider = (_ view: View, _ indexPath: IndexPath, _ item: Item) -> Cell?
    
    // MARK: - Data
    
    public private(set) var sections: [Section] = []
    public private(set) var data: [Section: [Item]] = [:] {
        didSet {
            guard automaticReloadData else { return }
            reloadableView?.reloadData()
        }
    }
    
    // MARK: - Providers
    
    public var itemProvider: ItemProvider?
    
    // MARK: - Initializer
    
    public init(view: View, itemProvider: ItemProvider? = nil) {
        super.init()
        self.reloadableView = view
        self.itemProvider = itemProvider
    }
    
    // MARK: - Data management
    
    /// Adds a section to the data source
    /// - Parameter section: The section to be added to the data source
    /// - Note: If the section is already present, the data source does not change
    public func add(section: Section) {
        if !sections.contains(section) {
            sections.append(section)
            data[section] = []
        }
    }
    
    /// Add items to the given section
    /// - Parameters:
    ///   - items: The items to be added to the section
    ///   - section: A type that conforms to `Hashable` to represents a section
    /// - Note: If the section is not part of the data source, it will also add the section
    public func add(items: [Item], to section: Section) {
        add(section: section)
        var currentItems = data[section, default: []]
        currentItems.append(contentsOf: items)
        data[section] = currentItems
    }
    
    /// Updates the given section with the contents of the `items` parameter
    /// - Parameters:
    ///   - items: Items to replace the contents of the section
    ///   - section: The section to be updated
    /// - Note: If the section doesn't exists the data source does not change
    public func update(items: [Item], from section: Section) {
        if sections.contains(section) {
            data[section] = items
        }
    }
    
    /// Removes an entire section from the data source
    /// - Parameter section: The section to be removed
    public func remove(section: Section) {
        sections.removeAll(where: { $0.hashValue == section.hashValue })
        data.removeValue(forKey: section)
    }

    /// Sort sections
    /// - Parameters:
    ///   - sections: An closure to determine the order of the sections
    /// - Note: If the section doesn't exists the data source does not change
    public func sort(sections sortCompletion: (Section, Section) throws -> Bool) throws {
        try sections.sort(by: sortCompletion)
    }
    
    /// - Parameter indexPath: The item `IndexPath`
    /// - Returns: Returns the item at the given `IndexPath` if the item exists, otherwise returns `nil`
    public func item(at indexPath: IndexPath) -> Item? {
        data[sections[indexPath.section]]?[indexPath.row]
    }
}
