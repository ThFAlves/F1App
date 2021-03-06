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
    
    private func getData(in fileName: String) -> SeasonData {
        let trackingData = try! MockCodable<SeasonData>().loadCodableObject(
            resource: fileName,
            typeDecoder: .useDefaultKeys)
        return trackingData
    }
    
    // MARK: - Public Methods
    func testDidNextStep_WhenSelectDetail_ShouldOpenDetail() {
        sut.didNextStep(action: .detail(round: "1"))
        XCTAssertEqual(coordinatorSpy.action, [.detail(round: "1")])
    }
    
    func testPresentError_WhenReceiveTimeout_ShouldPresentError() {
        sut.presentError(apiError: .timeout)
        XCTAssertEqual(viewControllerSpy.callDisplayErrorCount, 1)
        XCTAssertNotNil(viewControllerSpy.apiError)
        XCTAssertEqual(viewControllerSpy.apiError?.message, "Você está sem internet")
    }
    
    func testPresentRaces_WhenReceiveEmptyRaces_ShouldPresentRaces() {
        sut.presentRaces(races: getData(in: "mockSeasonData").data.raceTable.races)
        XCTAssertEqual(viewControllerSpy.callDisplayRaceListCount, 1)
        XCTAssertEqual(viewControllerSpy.races.count, 17)
    }
    
    func testPresentStartLoading_WhenStartLoading_ShouldPresentLoading() {
        sut.presentStartLoading()
        XCTAssertEqual(viewControllerSpy.callDisplayStartLoadingCount, 1)
        XCTAssertEqual(viewControllerSpy.callDisplayStopLoadingCount, 0)
    }
    
    func testPresentStopLoading_WhenStopLoading_WhenPresentStopLoading() {
        sut.presentStopLoading()
        XCTAssertEqual(viewControllerSpy.callDisplayStartLoadingCount, 0)
        XCTAssertEqual(viewControllerSpy.callDisplayStopLoadingCount, 1)
    }
}
