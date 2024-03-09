import UIKit

public protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    
    // MARK: Properties
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private let formatter = ISO8601DateFormatter()
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private init() { }
    
    // MARK: Methods
    
    func fetchPhotosNextPage() {
        let nextPage = self.lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        assert(Thread.isMainThread)
        guard task == nil else {
            return
        }
        let perPage: Int = 10
        let path = "/photos" +
                   "?page=\(nextPage)" +
                   "&&per_page=\(perPage)"
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: "GET")
        guard let token = OAuth2TokenStorage.shared.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.data(request: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case.success(let photoResult):
                var photos: [Photo] = []
                for i in 0..<perPage {
                    photos.append(
                        Photo(
                            id: photoResult[i].id,
                            size: CGSize(width: photoResult[i].width, height: photoResult[i].height),
                            createdAt: self.formatter.date(from: photoResult[i].createdAt ?? ""),
                            welcomeDescription: photoResult[i].description ?? "",
                            thumbImageURL: photoResult[i].urls.small,
                            largeImageURL: photoResult[i].urls.full,
                            isLiked: photoResult[i].likedByUser))
                }
                self.task = nil
                self.lastLoadedPage = nextPage
                self.photos.append(contentsOf: photos)
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["Photos": self.photos])
            case.failure(let error):
                print(error.localizedDescription)
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        let path = "/photos/\(photoId)/like"
        let httpMethod = isLike ? "POST" : "DELETE"
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: httpMethod)
        guard let token = OAuth2TokenStorage.shared.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.data(request: request) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case.success(let resultLike):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index].isLiked = resultLike.photo.likedByUser
                }
                completion(.success(resultLike.photo.likedByUser))
            case.failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
