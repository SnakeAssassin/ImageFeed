import Foundation
/// Здесь будет реализована логика запроса из контроллера в презентер

/// II. Объявляем протокол с переменной вью контроллера
/// через которую мы будем обращаться к WebViewViewController()
public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    
    /// 2.3 Создаем метод
    func viewDidLoad()
    
    /// 3.3 Чтобы презентер получал от вью уведомления об изменении значения прогресса
    /// добавляем метод
    func didUpdateProgressValue(_ newValue: Double)
    
    /// 4.1 Выносим обработку ответа и получаем код
    func code(from url: URL) -> String?
}

/// Класс реализует протокол и создает переменную вью контроллера
final class WebViewPresenter: WebViewPresenterProtocol {
    
    
    var view: WebViewViewControllerProtocol?
    
    /// 5.4 Добавляем хелпер в презентер
    var authHelper: AuthHelperProtocol
    
    /// 5.5 Инициализируем добавленный хелпер
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    /// 2.4 Реализуем метод в презентере
    /// Request URL
    func viewDidLoad() {
        /// 5.6.1 Заменяем на реквест из хелпера
        guard let request = authHelper.authRequest() else { return }
//        guard var urlComponents = URLComponents(string: AuthConfiguration.standard.authURLString) else {
//            return
//        }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
//            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: AuthConfiguration.standard.accessScope)
//        ]
//        
//        guard let url = urlComponents.url else { return }
//        let request = URLRequest(url: url)
        
        /// 3.6 Вместо того, чтобы вызывать updateProgress() в viewDidLoad вьюконтроллера, мы вызовем didUpdateProgressValue(0) во viewDidLoad презентера
        didUpdateProgressValue(0)   // Инициируем начало загрузки в отображении полоски загрузки
        view?.load(request: request)    // Передаем результат в WebViewViewController()
    }
    
    /// 3.4 Реализуем метод в презентере
    /// Set Progress
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let hideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(hideProgress)
    }
    
    /// Функция вычисления того, должен ли быть скрыт progressView.
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    /// 4.2 Реализуем метод
    /// Autorisation Code
//    func code(from url: URL) -> String? {
//        if let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == "/oauth/authorize/native",
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
//    }
    
    /// 5.6.2 Изменяем метод на код из хелпера
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}


