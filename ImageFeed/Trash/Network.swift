/* import Foundation
final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue ?? ""
        }
    }
    
    /// Метод запрашивает Bearer-токен и сохраняет в UserDefaults
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ){
        /// Формирование URL и httpRequest
        let request = authTokenRequest(code: code)
        /// Формирование HTTP-запроса
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            /// Обработка данных, после получения ответа от сервера
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        /// Отправка запроса на сервер
        task.resume()
    }
}
    
*/
    
    
    
/*
    
    // Метод запрашивает Bearer-токен
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ){
        /// 1. Формирование HTTP-запроса (POST) через метод 2.1 authTokenRequest -> URLRequest
        let request = authTokenRequest(code: code)
        /// 2. Отправка асинхронного HTTP-запроса и обработка ответа (в замыкании вернется OAuthTokenResponseBody
        let task = object(for: request) { /*[weak self]*/ result in
            /*guard let self = self else {
                print("result or error")
                return
            }*/
            
            /// 3. Обработка ответа
            switch result {
            // Если запрос успешен, то извлекается токен доступа и сохраняется в authToken, который пишется в UserDefaults
            case .success(let body):
                print("print struct")
                print(body.accessToken)
                print(body.tokenType)
                print(body.scope)
                print(body.createdAt)
                
                
                let authToken = body.accessToken
                print("ok")
                print(authToken)
                
                
                self.authToken = authToken
                // Вызывается completion с успешным результатом ???
                completion(.success(authToken))
            // Если запрос неуспешен, то через completion передается ошибка для последующей обработки
            case .failure(let error):
                completion(.failure(error))
                print("error")
                print(error)
            }
        }
        // Запуск асинхронной задачи, представленной объектом URLSessionTask, который был возвращен из метода object(for:completion:).
        task.resume()
        print("Значение в UserDefaults: \(UserDefaults.standard.object(forKey: "OAuth2TokenKey") as Any)")
        
        if let tokenValue = UserDefaults.standard.string(forKey: "OAuth2TokenKey") {
            print("Token: \(tokenValue)")
        } else {
            print("Token not found in UserDefaults")
        }
        
    }
}

*/
/*
extension OAuth2Service {
    
    // 3.1 Метод возвращает URLSessionTask, представляющую асинхронную задачу (так как внутри него используется метод urlSession.data(for:completion:), который представляет асинхронную операцию получения данных по сети.), которая была создана при отправке запроса. Это может быть полезно, например, для отмены задачи в случае необходимости:
    // -> Возвращает URLSessionTask
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        // Создаем декодер
        // let decoder = JSONDecoder()
        print("1")
        // 1. Отправка HTTP-запроса: URLSession.shared.data(URL) -> ожидаем Data или Error
        // Сокращение urlSession = URLSession.shared
        return URLSession.shared.data(for: request) { (result: Result<Data, Error>) in
            // 2. Внутри этого замыкания создается новый Result под названием response. Этот Result создается с использованием метода flatMap, который принимает данные из Result<Data, Error>
            print("2")
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                // 3. и пытается декодировать их в объект типа OAuthTokenResponseBody с использованием JSONDecoder.
                // 4. Если декодирование проходит успешно, создается новый Result.success с декодированным объектом и возвращает OAuthTokenResponseBody. Если декодирование вызывает ошибку, создается новый Result.failure и возвращает Error.
                Result { try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            // 5. Результат response передается в замыкание completion, которое было передано в качестве аргумента функции object(for:completion:).
            print("3")
            completion(response)
        }
    }
    
    
    extension OAuth2Service {
        private func object(
            for request: URLRequest,
            completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
        ) -> URLSessionTask {
            let decoder = JSONDecoder()
            return urlSession.data(for: request) { (result: Result<Data, Error>) in
                let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                    Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
    }
                completion(response)
            }
    }
    
    
    // 2.1 Создание URL для HTTP-запроса с передачей "code" и задание Request-метода
    // -> Возвращает URLRequest
    private func authTokenRequest(code: String) -> URLRequest {
        // 2.1.1 Вызываем из расширения метод для формирования URL и глагола и передаем URLRequest
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
    
    
}



// MARK: - HTTP Request
/// 1.1 Создание URL с использованием URLRequest:
fileprivate let DefaultBaseURL = URL(string: "https://api.unsplash.com")!

/// 1.2 Создание URL с использованием URLComponents:
/// var urlComponents = URLComponents()
/// urlComponents.scheme = "https"                    // протокол, по которому доступен ресурс http или https
/// urlComponents.host = "api.unsplash.com"     // имя хоста: DNS или IP-адрес или URL
/// urlComponents.path = "/me"                           // путь до ресурса
/// let url = urlComponents.url!                             // склейка компонентов и формирование URL

extension URLRequest {
    
    // 2.1.1 Метод формирует HTTP-запрос с URL и глаголом
    // -> возвращает URLRequest
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = DefaultBaseURL) -> URLRequest {
        // 2.1.2 Создание HTTP-запроса с заданным URL
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        
        // 2.1.3 Изменение HTTP-глагола
        request.httpMethod = httpMethod
        return request
    }
}

// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}



extension URLSession {
    
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}

*/
