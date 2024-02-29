import UIKit

// MARK: - OAuth2Service

final class OAuth2Service {
    
    // MARK: Private properties
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
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
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let path = "/oauth/token" +
        "?client_id=\(AuthConfiguration.standard.accessKey)" +
        "&&client_secret=\(AuthConfiguration.standard.secretKey)" +
        "&&redirect_uri=\(AuthConfiguration.standard.redirectURI)" +
                   "&&code=\(code)" +
                   "&&grant_type=authorization_code"
        let request = URLRequest.makeHTTPRequest(path: path, httpMethod: "GET", baseURL: AuthConfiguration.standard.defaultBaseURL)
        let task = urlSession.data(request: request) { [weak self] (result: Result<OAuthTokenResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let responseBody):
                let authToken = responseBody.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                print("[OAuth2Service/task]: Ошибка получения Auth Token - \(error)")
                completion(.failure(error))
                self.lastCode = nil
            }
        }
        task.resume()
    }
}
