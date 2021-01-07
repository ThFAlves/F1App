import XCTest
@testable import F1

private final class PitStopsPresenterSpy: InteractorToPresenterPitStopsProtocol {
    // MARK: - Variables
    var viewController: RaceDetailDisplaying?
    
    private(set) var callPresentPitStopsCount = 0
    private(set) var pitStops = [PitStopsResults]()
    private(set) var callPresentErrorCount = 0
    private(set) var apiError: ApiError?
    private(set) var callStartLoadingCount = 0
    private(set) var callStopLoadingCount = 0

    // MARK: - Public Methods
    func displayPitStopsList(list: [PitStopsResults]) {
        callPresentPitStopsCount += 1
        pitStops = list
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

private final class PitStopsServiceSpy: PitStopsServicing {
    // MARK: - Variables
    private(set) var updateModelCalledCount = 0
    public var result: Result<PitStopsData, ApiError>!
    
    // MARK: - Public Methods
    func getPitStops(round: String, completion: @escaping CompletionPitStopsData) {
        updateModelCalledCount += 1
        completion(result)
    }
}

final class PitStopsInteractorTests: XCTestCase {
    // MARK: - Variables
    private let serviceSpy = PitStopsServiceSpy()
    private let presenterSpy = PitStopsPresenterSpy()
    
    private lazy var sut: PitStopsInteractor = {
        let sut = PitStopsInteractor(service: serviceSpy, round: "1")
        sut.presenter = presenterSpy
        return sut
    }()
    
    private func getData(in fileName: String) -> PitStopsData {
        let trackingData = try! MockCodable<PitStopsData>().loadCodableObject(
            resource: fileName,
            typeDecoder: .useDefaultKeys)
        return trackingData
    }
    
    // MARK: - Public Methods
    func testGetResult_WhenResulIsFailure_ShouldPresentError() {
        serviceSpy.result = .failure(.timeout)
        sut.getPitStops()
        XCTAssertEqual(presenterSpy.pitStops.count, 0)
        XCTAssertEqual(presenterSpy.callPresentPitStopsCount, 0)
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 1)
        XCTAssertNotNil(presenterSpy.apiError)
    }
    
    func testGetResult_WhenResulIsSuccess_ShouldPresentData() {
        serviceSpy.result = .success(getData(in: "mockPitStops"))
        sut.getPitStops()
        XCTAssertEqual(presenterSpy.pitStops.count, 30)
        XCTAssertEqual(presenterSpy.callPresentPitStopsCount, 1)
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 0)
        XCTAssertNil(presenterSpy.apiError)
    }
}
