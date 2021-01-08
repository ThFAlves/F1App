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
    
    func presentStartLoading(hasContent: Bool) {
        callStartLoadingCount += 1
    }
    
    func presentStopLoading(hasContent: Bool) {
        callStopLoadingCount += 1
    }
}

private final class PitStopsServiceSpy: PitStopsServicing {
    // MARK: - Variables
    private(set) var updateModelCalledCount = 0
    public var result: Result<PitStopsData, ApiError> = .failure(.badRequest)
    
    // MARK: - Public Methods
    func getPitStops(round: String, offSet: Int, completion: @escaping CompletionPitStopsData) {
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
    func testGetPitStops_WhenResulIsFailure_ShouldPresentError() {
        serviceSpy.result = .failure(.timeout)
        sut.getPitStops(offSet: 0)
        XCTAssertEqual(presenterSpy.pitStops.count, 0)
        XCTAssertEqual(presenterSpy.callPresentPitStopsCount, 0)
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 1)
        XCTAssertNotNil(presenterSpy.apiError)
    }
    
    func testGetPitStops_WhenResulIsSuccess_ShouldPresentData() {
        serviceSpy.result = .success(getData(in: "mockPitStops"))
        sut.getPitStops(offSet: 0)
        XCTAssertEqual(presenterSpy.pitStops.count, 30)
        XCTAssertEqual(presenterSpy.callPresentPitStopsCount, 1)
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 0)
        XCTAssertNil(presenterSpy.apiError)
    }
    
    func tesFetchMoreItensIfNeeded_WhenHasRequest_ShouldNotFetchData() {
        sut.hasRequest = true
        sut.fetchMoreItensIfNeeded(IndexPath(row: 0, section: 0))
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 0)
    }
    
    func tesFetchMoreItensIfNeeded_WhenCanFetch_ShouldPresentDataAndAppendValues() {
        serviceSpy.result = .success(getData(in: "mockPitStops"))
        let pitStops = getData(in: "mockPitStops").data.raceTable
        sut.hasRequest = false
        sut.pitStopsResult = pitStops.races.first?.pitStopsResult ?? []
        sut.page = Page(pitStopData: PMPitStopsData(limit: "10", offset: "0", total: "45", raceTable: pitStops))
        sut.fetchMoreItensIfNeeded(IndexPath(row: 29, section: 0))
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.pitStops.count, 30)
        XCTAssertEqual(sut.pitStopsResult.count, 60)
        XCTAssertEqual(presenterSpy.callPresentPitStopsCount, 1)
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callStopLoadingCount, 1)
        XCTAssertEqual(presenterSpy.callPresentErrorCount, 0)
        XCTAssertNil(presenterSpy.apiError)
    }
    
    func tesFetchMoreItensIfNeeded_WhenHasNotFinished_ShoulFetchData() {
        let pitStops = getData(in: "mockPitStops").data.raceTable
        sut.hasRequest = false
        sut.pitStopsResult = pitStops.races.first?.pitStopsResult ?? []
        sut.page = Page(pitStopData: PMPitStopsData(limit: "10", offset: "0", total: "45", raceTable: pitStops))
        sut.fetchMoreItensIfNeeded(IndexPath(row: 29, section: 0))
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 1)
    }
    
    func tesFetchMoreItensIfNeeded_WhenHasFinished_ShouldNotFetchData() {
        serviceSpy.result = .success(getData(in: "mockPitStops"))
        let pitStops = getData(in: "mockPitStops").data.raceTable
        sut.hasRequest = false
        sut.pitStopsResult = pitStops.races.first?.pitStopsResult ?? []
        sut.page = Page(pitStopData: PMPitStopsData(limit: "10", offset: "40", total: "45", raceTable: pitStops))
        sut.fetchMoreItensIfNeeded(IndexPath(row: 29, section: 0))
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 0)
    }
    
    func tesFetchMoreItensIfNeeded_WhenHasIndexNotAtEnd_ShouldNotFetchData() {
        let pitStops = getData(in: "mockPitStops").data.raceTable
        sut.hasRequest = false
        sut.pitStopsResult = pitStops.races.first?.pitStopsResult ?? []
        sut.page = Page(pitStopData: PMPitStopsData(limit: "10", offset: "0", total: "45", raceTable: pitStops))
        sut.fetchMoreItensIfNeeded(IndexPath(row: 20, section: 0))
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 0)
    }
    
    func tesFetchMoreItensIfNeeded_WhenHasEmptyList_ShouldNotFetchData() {
        sut.pitStopsResult = []
        sut.fetchMoreItensIfNeeded(IndexPath(row: 0, section: 0))
        XCTAssertEqual(presenterSpy.callStartLoadingCount, 0)
    }
    
    func testJFFI() {
    }
}
