import UIKit

// MARK: - OAuth2Service

final class OAuth2Service {
    
    // MARK: Private properties
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
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
        
        let request = authTokenRequest(code: code)
        let task = object(for: request, service: self) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


// MARK: - Network Service

extension OAuth2Service {
    
    private func authTokenRequest(code: String) -> URLRequest {
        
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: BaseURL
        )
    }
    
    private func object(for request: URLRequest, service: OAuth2Service, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        return urlSession.data(for: request)  { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(responseBody))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
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

extension URLRequest {
    
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = DefaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}


// MARK: - HTTP Session

extension URLSession {
    
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    print("Получен ответ Status Code >300:")
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("Получена ошибка запроса: \(NetworkError.urlRequestError(error))")
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Получена ошибка сессии: \(NetworkError.urlSessionError)")
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
