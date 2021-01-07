import XCTest
@testable import F1

private final class RaceDetailCoordinatorSpy: RaceDetailCoordinating {

    // MARK: - Variables
    var viewController: UIViewController?
    
    private(set) var action = [RaceDetailAction]()

    // MARK: - Public Methods
    func perform(action: RaceDetailAction) {
        self.action.append(action)
    }
}

final class RaceDetailViewControllerSpy: RaceDetailDisplaying {
        
    // MARK: - Variables
    private(set) var callDisplayDriverResultCount = 0
    private(set) var result = [DriverResult]()
    private(set) var callDisplayTitleCount = 0
    private(set) var title: String?
    private(set) var callDisplayErrorCount = 0
    private(set) var apiError: ApiError?
    private(set) var callDisplayStartLoadingCount = 0
    private(set) var callDisplayStopLoadingCount = 0
    
    func displayDriverResult(driver: [DriverResult]) {
        callDisplayDriverResultCount += 1
        result = driver
    }
    
    func displayTitle(_ titleScreen: String) {
        callDisplayTitleCount += 1
        title = titleScreen
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

final class RaceDetailPresenterTests: XCTestCase {
    // MARK: - Variables
    private var coordinatorSpy = RaceDetailCoordinatorSpy()
    private let viewControllerSpy = RaceDetailViewControllerSpy()
    
    private lazy var sut: RaceDetailPresenter = {
        let sut = RaceDetailPresenter(coordinator: coordinatorSpy)
        sut.viewController = viewControllerSpy
        return sut
    }()
    
    private func getData(in fileName: String) -> DriverData {
        let trackingData = try! MockCodable<DriverData>().loadCodableObject(
            resource: fileName,
            typeDecoder: .useDefaultKeys)
        return trackingData
    }
    
    // MARK: - Public Methods
    func testDidNextStep_WhenReceiveValidUrl_ShouldOpenWebView() throws {
        let url = try XCTUnwrap(URL(string: "testUrl"))
        sut.didNextStep(action: .open(url: url))
        XCTAssertEqual(coordinatorSpy.action, [.open(url: url)])
    }
    
    func testPresentError_WhenBadReqeuest_ShouldReceiveErrorAlert() {
        sut.presentError(apiError: .badRequest)
        XCTAssertEqual(viewControllerSpy.callDisplayErrorCount, 1)
        XCTAssertNotNil(viewControllerSpy.apiError)
    }
    
    func testPresentDrivers_WhenEmpty_ShouldUpdateScreen() {
        sut.presentDrivers(drivers: [])
        XCTAssertEqual(viewControllerSpy.callDisplayDriverResultCount, 1)
        XCTAssertEqual(viewControllerSpy.result.count, 0)
    }
 
    func testPresentDrivers_WhenNotEmpty_ShouldUpdateScreen() throws {
        let result = try XCTUnwrap(getData(in: "mockResults").data.raceTable.races.first?.results)
        sut.presentDrivers(drivers: result)
        XCTAssertEqual(viewControllerSpy.callDisplayDriverResultCount, 1)
        XCTAssertEqual(viewControllerSpy.result.count, 20)
    }
    
    func testPresentTitle_WhenReceiveRaceName_ShouldUpdateScreen() {
        let title = "GP do Brasil"
        sut.presentTitle(title)
        XCTAssertEqual(viewControllerSpy.callDisplayTitleCount, 1)
        XCTAssertEqual(viewControllerSpy.title, title)
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

