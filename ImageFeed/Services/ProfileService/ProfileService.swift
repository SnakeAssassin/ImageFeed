import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?           // 1. Для проверки активных задач (если нет - nil)
    private(set) var profile: Profile?
    
    private init() { }
    
    internal func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        /// Блок проверки запущенных запросов в сеть, для исключения ситуации гонки из-за запросов более одного
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
                self.task = nil                                     // Обнуляем таск так как обработка завершена
            case.failure(let error):
                print("Ошибка получения данных профиля: \(error)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}


