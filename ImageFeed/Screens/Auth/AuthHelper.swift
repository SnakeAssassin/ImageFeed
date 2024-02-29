import Foundation

/// Мы хотим вынести в него из презентера два метода:
/// - создание запроса к серверу,
/// - получение кода из ответа.

/// 5.1. Создаем протокол
protocol AuthHelperProtocol {
    /// Методы для обращения из презентера
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

/// 5.2. Создаем класс, реализующий этот протокол
final class AuthHelper: AuthHelperProtocol {

    /// 5.2.1 Для работы с авторизационными данными будем передавать ему структуру AuthConfiguration
    let configuration: AuthConfiguration

    /// 5.2.2 При инициализации заполяем структуру дефолтными значениями для работы с сеть/
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    /// 5.3. Реализация методов протокола AuthHelperProtocol
   
    /// Собираем URL (вынесли отдельный метод authURL() -> URL для удобства тестирования)
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.authURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        return urlComponents.url
    }
    
    /// 5.3.1 Передаем Request с URL
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }
    
    /// 5.3.2 Достаем код
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
}
