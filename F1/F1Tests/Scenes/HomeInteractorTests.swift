import XCTest
@testable import F1

private final class HomePresenterSpy: HomePresenting {

    // MARK: - Variables
    var viewController: HomeDisplaying?
    
    private(set) var action = [HomeAction]()
    private(set) var callRacesCount = 0
    private(set) var races = [Race]()
    private(set) var callPresentErrorCount = 0
    private(set) var apiError: ApiError?
    private(set) var callPresentStartLoadingCount = 0
    private(set) var callPresentStopLoadingCount = 0

    // MARK: - Public Methods
    func presentRaces(races: [Race]) {
        callRacesCount += 1
        self.races = races
    }
    
    func presentError(apiError: ApiError) {
        callPresentErrorCount += 1
        self.apiError = apiError
    }
    
    func presentStartLoading() {
        callPresentStartLoadingCount += 1
    }
    
    func presentStopLoading() {
        callPresentStopLoadingCount += 1
    }
    
    func didNextStep(action: HomeAction) {
        self.action.append(action)
    }
}

private final class HomeServiceSpy: HomeServicing {

    // MARK: - Variables
    private(set) var updateModelCalledCount = 0
    public var result: Result<SeasonData, ApiError>!
    
    // MARK: - Public Methods
    func getCurrentSeason(completion: @escaping CompletionSeasonData) {
        updateModelCalledCount += 1
        completion(result)
    }
}

final class HomeInteractorTests: XCTestCase {
    // MARK: - Variables
    private var presenterSpy = HomePresenterSpy()
    private let serviceSpy = HomeServiceSpy()
    
    private lazy var sut = HomeInteractor(service: serviceSpy, presenter: presenterSpy)
    
    // MARK: - Public Methods
    func testLoadCurrentSeason_WhenResultIsError_ShouldPresentError() {
        serviceSpy.result = .failure(.timeout)
        sut.loadCurrentSeason()
        XCTAssertEqual(presenterSpy.callPresentStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 1)
        XCTAssertEqual(presenterSpy.action, [])
        XCTAssertNotNil(presenterSpy.apiError)
    }
    
    func testLoadCurrentSeason_WhenResultIsError_ShouldPresentError() {
        let seasonData = SeasonData(
        serviceSpy.result = .success(<#T##SeasonData#>)
        sut.loadCurrentSeason()
        XCTAssertEqual(presenterSpy.callPresentStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 1)
        XCTAssertEqual(presenterSpy.action, [])
        XCTAssertNotNil(presenterSpy.apiError)
    }
}

extension HomeAction: Equatable {
    public static func == (lhs: HomeAction, rhs: HomeAction) -> Bool {
        switch (lhs, rhs) {
        case let (.detail(round: lhsRound), .detail(rhsRound)):
            return lhsRound == rhsRound
        }
    }
}
