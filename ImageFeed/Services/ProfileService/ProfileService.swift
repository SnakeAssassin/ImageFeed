import Foundation

public protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    
    static let shared: ProfileServiceProtocol = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    private init() { }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.data(request: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case.success(let profile):
                self.profile = Profile(username: profile.username ?? "",
                                       name: (profile.firstName ?? "") + " " + (profile.lastName ?? ""),
                                       loginName: "@" + (profile.username ?? ""),
                                       bio: profile.bio ?? "")
                completion(.success(self.profile!))
                self.task = nil
            case.failure(let error):
                print("[ProfileService/task] Ошибка получения данных профиля – \(error)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}


