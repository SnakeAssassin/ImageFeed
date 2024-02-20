import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    /// 1. Имя нотификации
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() { }
    
    internal func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        guard let token = oauth2TokenStorage.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.data(request: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case.success(let user):
                self.avatarURL = user.profileImage!["large"]
                print(avatarURL)
                completion(.success(self.avatarURL!))
                /// 2. Публикация нотификации
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": self.avatarURL!])
                self.task = nil
            case.failure(let error):
                print("Ошибка получения аватара профиля: \(error)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
