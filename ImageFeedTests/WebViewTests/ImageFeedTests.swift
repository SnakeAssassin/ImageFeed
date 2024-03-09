@testable import ImageFeed
import XCTest

final class Image_FeedTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // Given:
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        _ = viewController.view
        // Then:
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
   
    func testPresenterCallsLoadRequest() {
        // Given:
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let viewController = WebViewViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        // When:
        presenter.viewDidLoad()
        // Then:
        XCTAssertTrue(viewController.presenterDidLoadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // Given:
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        // When:
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        // Then:
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        // Given:
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        // When:
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        // Then:
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        // Given:
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper()
        // When:
        guard let url = authHelper.authURL() else { return }
        let urlString = url.absoluteString
        // Then:
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        // Given:
        let authHelper = AuthHelper()
        // When:
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url
        let code = authHelper.code(from: url!)
        // Then:
        XCTAssertEqual(code, "test code")
    }
}
