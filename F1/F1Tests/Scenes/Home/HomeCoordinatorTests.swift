import XCTest
@testable import F1

final class HomeCoordinatorTests: XCTestCase {
    // MARK: - Variables
    private let viewControllerSpy = ViewControllerSpy()
    private lazy var navigationSpy = NavigationControllerSpy(rootViewController: viewControllerSpy)
    
    private lazy var sut: HomeCoordinator = {
        let sut = HomeCoordinator()
        sut.viewController = navigationSpy.topViewController
        return sut
    }()
    
    // MARK: - Public Methods
    func testPerform_WhenDetail_ShouldPresentScren() {
        sut.perform(action: .detail(round: "8"))
        XCTAssertEqual(navigationSpy.pushedCount, 2)
    }
}
