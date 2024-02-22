import UIKit

final class ImagesListService {
    
    static let shared = ImagesListService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private init() { }
    
    
    internal func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let pageNumber: Int = 1
        let perPage: Int = 10
        let path = "/photos" +
                   "?page=\(pageNumber)" +
                   "&&per_page=\(perPage)"
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("request: \(request)")
        let task = urlSession.data(request: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case.success(let photoResult):
                var photos: [Photo] = []
                for i in 0..<perPage {
                    photos.append(Photo(id: photoResult[i].id,
                                             size: CGSize(width: photoResult[i].width, height: photoResult[i].height),
                                             createdAt: photoResult[i].createdAt.toDate(),
                                             welcomeDescription: photoResult[i].description,
                                             thumbImageURL: photoResult[i].urls.thumb,
                                             largeImageURL: photoResult[i].urls.full,
                                             isLiked: photoResult[i].likedByUser))
                }
                self.photos.append(contentsOf: photos)
                completion(.success(self.photos))

                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["Photos": self.photos])
                
                self.task = nil
            case.failure(let error):
                print("[ImagesListService/task]: Ошибка получения данных фотографий - \(error)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
