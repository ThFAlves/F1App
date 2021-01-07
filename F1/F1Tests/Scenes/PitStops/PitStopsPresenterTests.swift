import XCTest
@testable import F1

final class PitStopsInteractorSpy: PresenterToInteractorPitStopsProtocol {
    // MARK: - Variables
    private(set) var callGetPitStopsCount = 0

    func getPitStops() {
        callGetPitStopsCount += 1
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
    private(set) var callDisplayStopLoadingCount = 0
    
    func displayPitStopsList(list: [PitStopsResults]) {
        callDisplayPitStopsResultCount += 1
        result = list
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
    
    func testAAA() {
        sut.getPitStops()
        XCTAssertEqual(interactorSpy.callGetPitStopsCount, 1)
    }
    
    func testPresentError_WhenBadReqeuest_ShouldReceiveErrorAlert() {
        sut.presentError(apiError: .badRequest)
        XCTAssertEqual(viewControllerSpy.callDisplayErrorCount, 1)
        XCTAssertNotNil(viewControllerSpy.apiError)
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


