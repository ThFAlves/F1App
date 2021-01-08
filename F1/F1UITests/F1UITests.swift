import XCTest

class F1UITests: XCTestCase {
    func testOpenRaceDetail() throws {
        let app = XCUIApplication()
        app.launch()

        let collectionViewsQuery = XCUIApplication().collectionViews
        collectionViewsQuery.cells.otherElements.containing(.staticText, identifier:"Austrian Grand Prix").staticTexts["Lat: 47.2197 Lon: 14.7647"].tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Monegasque - 16"]/*[[".cells.staticTexts[\"Monegasque - 16\"]",".staticTexts[\"Monegasque - 16\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testOpenWebView() {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Austrian Grand Prix").staticTexts["Red Bull Ring"].tap()
        app.navigationBars["Austrian Grand Prix"].children(matching: .button).element(boundBy: 1).tap()
    }
    
    func testOpenPitStops() {
        let app = XCUIApplication()
        app.launch()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Styrian Grand Prix"]/*[[".cells.staticTexts[\"Styrian Grand Prix\"]",".staticTexts[\"Styrian Grand Prix\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Styrian Grand Prix"].children(matching: .button).element(boundBy: 1).tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Kevin_Magnussen"]/*[[".cells.staticTexts[\"Kevin_Magnussen\"]",".staticTexts[\"Kevin_Magnussen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Time: 15:53:38 - Duration: 21.376"]/*[[".cells.staticTexts[\"Time: 15:53:38 - Duration: 21.376\"]",".staticTexts[\"Time: 15:53:38 - Duration: 21.376\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        
        
    }
}
