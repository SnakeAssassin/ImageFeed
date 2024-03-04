import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("example@gmail.com")
        webView.staticTexts["Login"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("*********")
        webView.staticTexts["Login"].tap()
        
        webView.buttons["Login"].tap()
        sleep(3)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.waitForExistence(timeout: 5)
    }
    
    func testFeed() throws {
        
        let tablesQuery = app.tables
        let cell1 = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell1.waitForExistence(timeout: 5))
        
        cell1.swipeUp()
        sleep(2)
        
        let cell2 = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        cell2.buttons["likeButtonIdentifier"].tap()
        sleep(5)
        cell2.buttons["likeButtonIdentifier"].tap()
        sleep(1)
        
        cell2.tap()
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 10))
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        app.buttons["backToImagesList"].tap()
        sleep(4)
    }
    
    
    func testProfile() throws {

        sleep(3)

        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(2)
        
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)

        app.buttons["LogoutButton"].tap()
        sleep(2)
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        
    }
}
