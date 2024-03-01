@testable import ImageFeed
import XCTest


final class Image_FeedTests: XCTestCase {
    
    /// 1. Тестируем связь контроллера и презентера
    /// Вьюконтроллер вызывает метод viewDidLoad презентера
    func testViewControllerCallsViewDidLoad() {
        //Given:
        // 1.1 Создать экземпляр вьюконтроллера:
        let viewController = WebViewViewController()
        
        // 1.2 Создать экземпляр презентера и соединить его с вьюконтроллером:
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter    // Вью -> Прзентер
        presenter.view = viewController         // Вью <- Презентер
        
        // When:
        // 1.3 Загрузить View, чтобы был вызван viewDidLoad вьюконтроллера:
        _ = viewController.view // *
        
        // Then:
        // 1.4 Проверить, что viewDidLoad презентера вызван:
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    /// * Нам надо проверить, что в презентере вызывается viewDidLoad.
    /// А вызывается он из viewDidLoad вьюконтроллера.
    /// Но если мы просто вызовем viewDidLoad вьюконтроллера, то приложение упадёт.
    /// Потому что этот метод должен вызываться только самой iOS, и уже после того, как вся предварительная работа по созданию и настройке View завершена.
    /// iOS запускает создание и настройку View с последующим вызовом viewDidLoad при самом первом обращении к View.
    /// Поэтому нам достаточно обратиться к View вьюконтроллера вот так: viewController.view.
    /// `_ = viewController.view` такая запись, так как сам результат этого обращения нам не нужен!
    
    /// 2. Тестируем связь между презентером и контроллером
    /// Презентер вызывает метод вьюконтроллера loadRequest
    func testPresenterCallsLoadRequest() {
        //Given:
        // 2.1 Создать экземпляр презентера
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        
        // 2.2 Создать экземпляр контроллера и соединить с презентером
        let viewController = WebViewViewControllerSpy()
        presenter.view = viewController                 // Вью -> презентером
        viewController.presenter = presenter            // вью <- Презентер
        
        // When:
        presenter.viewDidLoad()
        
        // Then:
        XCTAssertTrue(viewController.presenterDidLoadRequestCalled)
    }
    
    /// 3. Тестируем необходимость скрытия прогресса при 0.6
    func testProgressVisibleWhenLessThenOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    /// 4. Тестируем необходимость скрытия прогресса при 1
    func testProgressHiddenWhenOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    /// 5. Тестируем хелпер
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
    
    /// 6. Тестируем
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
        /*
         https://unsplash.com/oauth/authorize/native?code=41PC8bO2whMs0yhp6xBtYK8DRVHQZDhJ63OcNjawycA
         */
    }
}
