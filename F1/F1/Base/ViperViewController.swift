import UIKit

open class ViperViewController<Presenter, V: UIView>: UIViewController, ViewConfiguration {
    public let presenter: Presenter
    public var rootView = V()

    public init(presenter: Presenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    override open func loadView() {
        view = rootView
    }
    
    open func buildViewHierarchy() { }
    
    open func setupConstraints() { }
    
    open func configureViews() { }
}

extension ViperViewController where Presenter == Void {
    convenience init(_ presenter: Presenter = ()) {
        self.init(presenter: presenter)
    }
}
