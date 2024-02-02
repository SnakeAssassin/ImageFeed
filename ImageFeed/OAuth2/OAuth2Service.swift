import Foundation

final class OAuth2Service {
    /// При использовании экземпляра напрямую OAuth2Service().fetchOAuthToken создается новый экземпляр OAuth2Service при каждом вызове fetchOAuthToken. Это может привести к тому, что экземпляр OAuth2Service создается, выполняет запрос и затем деинициализируется, если нет других ссылок на него.
    /// Поэтому используется единый экземпляр OAuth2Service.shared.fetchOAuthToken(code), что должно решить проблему с его деинициализацией.
    /// shared - статическое свойство в классе OAuth2Service. Таким образом, при вызове OAuth2Service.shared будет использоваться существующий экземпляр, который живет в течение жизни приложения.
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    /// Сохранение токена в UsersDefaults
    private (set) var authToken: String? {
        get {
            print("6. Чтение токена в UsersDefaults")
            return OAuth2TokenStorage().token
        }
        set {
            print("6. Запись токена в UsersDefaults")
            OAuth2TokenStorage().token = newValue ?? "Пусто"
        }
    }
    
    
    /// Метод делает POST-запрос для получения Bearer-токена
    /// Функция fetchAuthToken вторым аргументом получает completion — блок, который нужно вызвать при получении результатов HTTP-запроса.
    /// Аргумент completion должен возвращать Swift.Result<String, Error>, где success сооветствует только ситуации, когда в ответе на запрос был получен положительный HTTP статус код (значение в дипазоне 200 — 299).
    /// ВАЖНО: Блок completion должен быть вызван на главном потоке (DispatchQueue.main). Это нужно, чтобы в будущем избежать ошибок, связанных, например, с попыткой обновить UI не из главного потока. В данной реализации переход на главный поток осуществляется в методе data сразу после получения ответа от сервера
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        /// 1. Формируем URL
        let request = authTokenRequest(code: code)
        print("1. Request сформирован")
        
        /// 2. Создаем задачу на отправление запроса и обработку полученного ответа
        let task = object(for: request, service: self) { [weak self] result in
            guard let self = self else {
                    print("service is nil")
                    return
                }

                print("service is NOT NIL")
                print(self)
                
                switch result {
                case .success(let body):
                    print("4. Ответ от сервера успешен. Токен:")
                    let authToken = body.accessToken
                    self.authToken = authToken
                    print(authToken)
                    completion(.success(authToken))
                case .failure(let error):
                    print("4. Ответ от сервера не успешен. Ошибка:")
                    print(error)
                    completion(.failure(error))
                }
            
        }
        
        
        print("2. Task сформирован")
        /// 3. Отправляем запрос на сервер
        task.resume()
        print("3. Task отправлен")
        //let tokenPrint = authToken
        //print("Значение tokenPrint\(String(describing: authToken))")
    }
}


// MARK: - Network Service

extension OAuth2Service {
    
    /// Метод формирует URL и метод запроса POST
    private func authTokenRequest(code: String) -> URLRequest {
        
        /// Создаем Request
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
    
    
    
    /// Метод URL с глаголом и декодирует результат ответа
    private func object(for request: URLRequest, service: OAuth2Service, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        print("5. Попытка декодировать полученные данные")
        
        return urlSession.data(for: request)  { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print("5. Результат декодирования: ")
                    print(responseBody)
                    completion(.success(responseBody))
                } catch {
                    print("5. Ошибка декодирования: ")
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("5. Ошибка при получении данных:")
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    
    /// Структура для декодирования JSON-ответа
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}


// MARK: - HTTP Request
// Если в вашем в проекте уже объявлена переменная `DefaultBaseURL` (с тем же значением),
// то строчку ниже можно удалить.
fileprivate let DefaultBaseURL = URL(string: "https://api.unsplash.com")!

extension URLRequest {
    
    /// Метод создает Request
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = DefaultBaseURL) -> URLRequest {
        
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}


    // MARK: Network Connection

    /// Обработка ошибок
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }


// MARK: - HTTP Session

extension URLSession {
    
    /// Метод создает, отправляет задачу и получает ответ от сервера
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        
        /// Результат возвращается в основной поток
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    print("4. Получен ответ Status Code 200..300:")
                    print(data)
                    fulfillCompletion(.success(data))
                } else {
                    print("4. Получен ответ Status Code >300:")
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("4. Получена ошибка запроса: \(NetworkError.urlRequestError(error))")
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("4. Получена ошибка сессии: \(NetworkError.urlSessionError)")
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
