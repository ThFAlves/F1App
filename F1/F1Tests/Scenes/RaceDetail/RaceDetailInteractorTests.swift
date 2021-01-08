import XCTest
@testable import F1

private final class RaceDetailPresenterSpy: RaceDetailPresenting {
    // MARK: - Variables
    var viewController: RaceDetailDisplaying?
    
    private(set) var action = [RaceDetailAction]()
    private(set) var callPresentDriversCount = 0
    private(set) var drivers = [DriverResult]()
    private(set) var callPresentTitleCount = 0
    private(set) var title: String?
    private(set) var callPresentErrorCount = 0
    private(set) var apiError: ApiError?
    private(set) var callStartLoadingCount = 0
    private(set) var callStopLoadingCount = 0

    // MARK: - Public Methods
    func didNextStep(action: RaceDetailAction) {
        self.action.append(action)
    }
    
    func presentDrivers(drivers: [DriverResult]) {
        callPresentDriversCount += 1
        self.drivers = drivers
    }
    
    func presentTitle(_ title: String) {
        callPresentTitleCount += 1
        self.title = title
    }
    
    func presentError(apiError: ApiError) {
        callPresentErrorCount += 1
        self.apiError = apiError
    }
    
    func presentStartLoading() {
        callStartLoadingCount += 1
    }
    
    func presentStopLoading() {
        callStopLoadingCount += 1
    }
}

private final class RaceDetailServiceSpy: RaceDetailServicing {

    // MARK: - Variables
    private(set) var updateModelCalledCount = 0
    public var result: Result<DriverData, ApiError>!
    
    // MARK: - Public Methods
    func getResult(round: String, completion: @escaping CompletionDriverData) {
        updateModelCalledCount += 1
        completion(result)
    }
}

final class RaceDetailInteractorTests: XCTestCase {
    // MARK: - Variables
    private var presenterSpy = RaceDetailPresenterSpy()
    private let serviceSpy = RaceDetailServiceSpy()
    
    private lazy var sut = RaceDetailInteractor(round: "2", service: serviceSpy, presenter: presenterSpy)
    
    private func getData(in fileName: String) -> DriverData {
        let trackingData = try! MockCodable<DriverData>().loadCodableObject(
            resource: fileName,
            typeDecoder: .useDefaultKeys)
        return trackingData
    }
    
    // MARK: - Public Methods
    func testGetResult_WhenResulIsFailure_ShouldPresentError() {
        serviceSpy.result = .failure(.timeout)
        sut.getResults()
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 1)
        XCTAssertNotNil(presenterSpy.apiError)
    }
    
    func testGetResult_WhenResulIsSuccess_ShouldPresentData() {
        serviceSpy.result = .success(getData(in: "mockResults"))
        sut.getResults()
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 0)
        XCTAssertNil(presenterSpy.apiError)
    }
    
    func testDidSelectItem_WhenRacesIsEmpty_ShouldIgnoreSelect() {
        sut.didSelectItem(row: 0)
        XCTAssertEqual(presenterSpy.action, [])
    }
    
    func testDidSelectItem_WhenRacesIsValidAndContains_ShouldCallAction() throws {
        let url = try XCTUnwrap(URL(string: "http://en.wikipedia.org/wiki/Lewis_Hamilton"))
        sut.drivers = getData(in: "mockResults").data.raceTable.races.first?.results ?? []
        sut.didSelectItem(row: 0)
        XCTAssertEqual(presenterSpy.action, [.open(url: url)])
    }
    
    func testDidSelectItem_WhenRacesIndexNotContains_ShouldIgnoreAction() {
        sut.drivers = getData(in: "mockResults").data.raceTable.races.first?.results ?? []
        sut.didSelectItem(row: 20)
        XCTAssertEqual(presenterSpy.action, [])
    }
}

extension RaceDetailAction: Equatable {
    public static func == (lhs: RaceDetailAction, rhs: RaceDetailAction) -> Bool {
        switch (lhs, rhs) {
        case let (.open(url: lhsUrl), .open(rhsUrl)):
            return lhsUrl == rhsUrl
        case let (.pitStops(lhsRound), .pitStops(rhsRound)):
            return lhsRound == rhsRound
        default:
            return false
        }
    }
}

