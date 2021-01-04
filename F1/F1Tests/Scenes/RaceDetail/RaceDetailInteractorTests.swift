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
    
    // MARK: - Public Methods
    func testLd() {
        serviceSpy.result = .failure(.timeout)
        sut.getResults()
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 1)
        XCTAssertEqual(presenterSpy.action, [])
        XCTAssertNotNil(presenterSpy.apiError)
    }
    
    func testKf() {
        sut.didSelectItem(row: 1)
        XCTAssertEqual(presenterSpy.action, [.open(url: URL(string: "testeUrl")!)])
    }
}

extension RaceDetailAction: Equatable {
    public static func == (lhs: RaceDetailAction, rhs: RaceDetailAction) -> Bool {
        switch (lhs, rhs) {
        case let (.open(url: lhsUrl), .open(rhsUrl)):
            return lhsUrl == rhsUrl
        }
    }
}

