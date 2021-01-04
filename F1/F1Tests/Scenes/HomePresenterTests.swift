import XCTest
@testable import F1

private final class HomeCoordinatorSpy: HomeCoordinating {
    
    // MARK: - Variables
    var viewController: UIViewController?
    
    private(set) var action = [HomeAction]()

    // MARK: - Public Methods
    func perform(action: HomeAction) {
        self.action.append(action)
    }
}

final class HomeViewControllerSpy: HomeDisplaying {
    
    // MARK: - Variables
    private(set) var callDisplayRaceListCount = 0
    private(set) var races = [Race]()
    private(set) var callDisplayErrorCount = 0
    private(set) var apiError: ApiError?
    private(set) var callDisplayStartLoadingCount = 0
    private(set) var callDisplayStopLoadingCount = 0
    
    func displayRaceList(races: [Race]) {
        callDisplayRaceListCount += 1
        self.races = races
    }
    
    func displayError(apiError: ApiError) {
        callDisplayErrorCount += 1
        self.apiError = apiError
    }
    
    func startLoading() {
        callDisplayStartLoadingCount += 1
    }
    
    func stopLoading() {
        callDisplayStopLoadingCount += 1
    }
}

final class HomePresenterTests: XCTestCase {
    // MARK: - Variables
    private var coordinatorSpy = HomeCoordinatorSpy()
    private let viewControllerSpy = HomeViewControllerSpy()
    
    private lazy var sut: HomePresenter = {
        let sut = HomePresenter(coordinator: coordinatorSpy)
        sut.viewController = viewControllerSpy
        return sut
    }()
    
    // MARK: - Public Methods
    func testL() {
        sut.didNextStep(action: .detail(round: "1"))
        XCTAssertEqual(coordinatorSpy.action, [.detail(round: "1")])
    }
    
    func testFKFK() {
        sut.presentError(apiError: .badRequest)
        XCTAssertEqual(viewControllerSpy.callDisplayErrorCount, 1)
        XCTAssertNotNil(viewControllerSpy.apiError)
    }
    
    func testFJRRI() {
        sut.presentRaces(races: [])
        XCTAssertEqual(viewControllerSpy.callDisplayRaceListCount, 1)
//        XCTAssertEqual(viewControllerSpy.races, [])
    }
    
    func testFJFIFU() {
        sut.presentStartLoading()
        XCTAssertEqual(viewControllerSpy.callDisplayStartLoadingCount, 1)
        XCTAssertEqual(viewControllerSpy.callDisplayStopLoadingCount, 0)
    }
    
    func testFJFIdFU() {
        sut.presentStopLoading()
        XCTAssertEqual(viewControllerSpy.callDisplayStartLoadingCount, 0)
        XCTAssertEqual(viewControllerSpy.callDisplayStopLoadingCount, 1)
    }
}
