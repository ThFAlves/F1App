import UIKit

protocol ViewConfiguration: AnyObject {
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
    func configureStyles()
    func buildLayout()
}

extension ViewConfiguration {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
        configureStyles()
    }
    
    func configureViews() { }

    func configureStyles() { }
}

open class ViewController<Interactor, V: UIView>: UIViewController, ViewConfiguration {
    public let interactor: Interactor
    public var rootView = V()

    public init(interactor: Interactor) {
        self.interactor = interactor
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

extension ViewController where Interactor == Void {
    convenience init(_ interactor: Interactor = ()) {
        self.init(interactor: interactor)
    }
}
