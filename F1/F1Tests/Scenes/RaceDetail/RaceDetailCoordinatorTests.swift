import XCTest
@testable import F1

final class RaceDetailCoordinatorTests: XCTestCase {
    // MARK: - Variables
    private let viewControllerSpy = ViewControllerSpy()
    private lazy var navigationSpy = NavigationControllerSpy(rootViewController: viewControllerSpy)
    
    private lazy var sut: RaceDetailCoordinator = {
        let sut = RaceDetailCoordinator()
        sut.viewController = navigationSpy.topViewController
        return sut
    }()
    
    // MARK: - Public Methods
    func testPerform_WhenOpenURL_ShouldPresentWebView() throws {
        let url = try XCTUnwrap(URL(string: "https://testUrl"))
        sut.perform(action: .open(url: url))
        XCTAssertEqual(navigationSpy.pushedCount, 1)
    }
    
    func testPerform_WhenOpenPitStops_ShouldPresentDetail() {
        sut.perform(action: .pitStops(round: "9"))
        XCTAssertEqual(navigationSpy.pushedCount, 2)
    }
}

