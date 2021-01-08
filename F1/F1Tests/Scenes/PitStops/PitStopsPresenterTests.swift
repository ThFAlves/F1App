import XCTest
@testable import F1

final class PitStopsInteractorSpy: PresenterToInteractorPitStopsProtocol {
    // MARK: - Variables
    private(set) var callGetPitStopsCount = 0
    private(set) var callFetchItensCount = 0

    func getPitStops(offSet: Int) {
        callGetPitStopsCount += 1
    }
    
    func fetchMoreItensIfNeeded(_ indexPath: IndexPath) {
        callFetchItensCount += 1
    }
}

final class PitStopsRouterSpy: PresenterToRouterPitStopsProtocol {}

final class PitStopsViewControllerSpy: PresenterToViewPitStopsProtocol {
    // MARK: - Variables
    private(set) var callDisplayPitStopsResultCount = 0
    private(set) var result = [PitStopsResults]()
    private(set) var callDisplayErrorCount = 0
    private(set) var apiError: ApiError?
    private(set) var callDisplayStartLoadingCount = 0
    private(set) var hasContentStartLoading: Bool?
    private(set) var callDisplayStopLoadingCount = 0
    private(set) var hasContentStopLoading: Bool?
    
    func displayPitStopsList(list: [PitStopsResults]) {
        callDisplayPitStopsResultCount += 1
        result = list
    }
    
    func displayError(apiError: ApiError) {
        callDisplayErrorCount += 1
        self.apiError = apiError
    }
    
    func startLoading(hasContent: Bool) {
        callDisplayStartLoadingCount += 1
        hasContentStartLoading = hasContent
    }
    
    func stopLoading(hasContent: Bool) {
        callDisplayStopLoadingCount += 1
        hasContentStopLoading = hasContent
    }
}

final class PitStopsPresenterTests: XCTestCase {
    // MARK: - Variables
    private var interactorSpy = PitStopsInteractorSpy()
    private let routerSpy = PitStopsRouterSpy()
    private let viewControllerSpy = PitStopsViewControllerSpy()
    
    private lazy var sut: PitStopsPresenter = {
        let sut = PitStopsPresenter(interactor: interactorSpy, router: routerSpy)
        sut.viewController = viewControllerSpy
        return sut
    }()
    
    private func getData(in fileName: String) -> PitStopsData {
        let trackingData = try! MockCodable<PitStopsData>().loadCodableObject(
            resource: fileName,
            typeDecoder: .useDefaultKeys)
        return trackingData
    }
    
    // MARK: - Public Methods
    func testDisplayPitStopsList_WhenGetValidData_WhenShowCorrectData() {
        sut.displayPitStopsList(list: getData(in: "mockPitStops").data.raceTable.races.first!.pitStopsResult)
        XCTAssertEqual(viewControllerSpy.callDisplayPitStopsResultCount, 1)
        XCTAssertEqual(viewControllerSpy.result.count, 30)
    }
    
    func testHasMoreItens_WhenReceiveValidPosition_ShouldCallFetch() {
        sut.hasMoreItens(IndexPath(row: 0, section: 0))
        XCTAssertEqual(interactorSpy.callFetchItensCount, 1)
    }
    
    func testGetPitStops_WhenRequest_ShouldCallInteractor() {
        sut.getPitStops()
        XCTAssertEqual(interactorSpy.callGetPitStopsCount, 1)
    }
    
    func testPresentError_WhenBadReqeuest_ShouldReceiveErrorAlert() {
        sut.presentError(apiError: .badRequest)
        XCTAssertEqual(viewControllerSpy.callDisplayErrorCount, 1)
        XCTAssertNotNil(viewControllerSpy.apiError)
    }
    
    func testPresentStartLoading_WhenStartLoading_ShouldPresentLoading() {
        sut.presentStartLoading(hasContent: true)
        XCTAssertEqual(viewControllerSpy.callDisplayStartLoadingCount, 1)
        XCTAssertEqual(viewControllerSpy.callDisplayStopLoadingCount, 0)
        XCTAssertEqual(viewControllerSpy.hasContentStartLoading, true)
        XCTAssertNil(viewControllerSpy.hasContentStopLoading)
    }
    
    func testPresentStopLoading_WhenStopLoading_WhenPresentStopLoading() {
        sut.presentStopLoading(hasContent: true)
        XCTAssertEqual(viewControllerSpy.callDisplayStartLoadingCount, 0)
        XCTAssertEqual(viewControllerSpy.callDisplayStopLoadingCount, 1)
        XCTAssertEqual(viewControllerSpy.hasContentStopLoading, true)
        XCTAssertNil(viewControllerSpy.hasContentStartLoading)
    }
}


