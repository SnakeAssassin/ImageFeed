import ImageFeed
import Foundation

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    var photos: [Photo] = []
    
    var fetchPhotosNextPageCalled = false
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    var changeLikeCalled = false
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> ()) {
        changeLikeCalled = true
    }
}
