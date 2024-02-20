import UIKit

// MARK: - OAuth2Service

final class OAuth2Service {
    
    // MARK: Private properties
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    //private var oAuthTokenTokenResponseBody: OAuthTokenResponseBody?
    
    private var task: URLSessionTask?           // 1. Для проверки активных задач (если нет - nil)
    private var lastCode: String?               // 2. Хранение кода из последнего созданного запроса (таска)
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage.shared.token
        }
        set {
            OAuth2TokenStorage.shared.token = newValue
        }
    }
    
    private init() { }
    
    // MARK: Methods
    internal func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("1")
        /// Блок проверки запущенных запросов в сеть, для исключения ситуации гонки из-за запросов более одного
        assert(Thread.isMainThread)             // Проверка, что этот код выполняется из главного потока
                                                // Если вернет false - приложение завершится
        
        if lastCode == code { return }          // Если code отличается от переданного ранее
        task?.cancel()                          // Отменяем предыдущий запрос, так как старый code устарел
        lastCode = code                         // Сохраняем текущий code
        
        let path = "/oauth/token"
        + "?client_id=\(AccessKey)"
        + "&&client_secret=\(SecretKey)"
        + "&&redirect_uri=\(RedirectURI)"
        + "&&code=\(code)"
        + "&&grant_type=authorization_code"
        let request = URLRequest.makeHTTPRequest(path: path, httpMethod: "GET", baseURL: BaseURL)
        
        print("2")
        let task = urlSession.data(request: request) { [weak self] (result: Result<OAuthTokenResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let responseBody):
                print("Успех")
                print(responseBody)
                let authToken = responseBody.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                print("Ошибка получения Auth Token: \(error)")
                
                completion(.failure(error))
                self.lastCode = nil
            }
        }
        
        
//        let task = object(for: request, service: self) { [weak self] result in
//            guard let self = self else {
//                return
//            }
//            switch result {
//            case .success(let body):
//                let authToken = body.accessToken
//                self.authToken = authToken
//                completion(.success(authToken))
//                self.task = nil                 // Обнуляем task, так как обработка завершена
//            case .failure(let error):
//                completion(.failure(error))
//                self.lastCode = nil             // Удаляем lastCode для повторного запроса с тем же кодом
//            }
//        }
        task.resume()
    }
}


// MARK: - Network Service

//extension OAuth2Service {
    
//    private func object(for request: URLRequest, service: OAuth2Service, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
//        
//        let decoder = JSONDecoder()
//        return urlSession.data(for: request)  { (result: Result<Data, Error>) in
//            switch result {
//            case .success(let data):
//                do {
//                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                    completion(.success(responseBody))
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    

//}




