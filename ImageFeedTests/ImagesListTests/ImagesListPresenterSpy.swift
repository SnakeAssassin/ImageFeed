import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {

    var view: ImageFeed.ImagesListControllerProtocol?
    var imagesListService: ImagesListServiceProtocol
    var viewDidLoadCalled = false
    var photo = Photo(
        id: "",
        size: CGSize(width: 0, height: 0),
        createdAt: Date(),
        welcomeDescription: "",
        thumbImageURL: "",
        largeImageURL: "",
        isLiked: false
    )
    var photosPhotosCount = 0
    var shouldFetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    var getCellDataCalled = false
    
    init(imagesListService: ImagesListServiceSpy){
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo {
        photo = Photo(
            id: "testId",
            size: CGSize(width: 100, height: 200),
            createdAt: nil,
            welcomeDescription: "testBio",
            thumbImageURL: "testThumb",
            largeImageURL: "testLarge",
            isLiked: true
        )
        return photo
    }

    func getPhotosCount() -> Int {
        photosPhotosCount = 10
        return photosPhotosCount
    }

    func shouldFetchPhotosNextPage(lastImage: Int/*, getOnlyFirstPageIn UITestMode: Bool*/) {
        shouldFetchPhotosNextPageCalled = true
    }

    func changeLike(indexPath: IndexPath, _ completion: @escaping (Result<Bool, Error>) -> ()) {
        changeLikeCalled = true
    }
    
    func getCellData(indexPath: IndexPath) -> (imageURL: String, isLiked: Bool, createdAt: String) {
        getCellDataCalled = true
        let imageURL = ""
        let isLiked = false
        let createdAt = ""
        return (imageURL, isLiked, createdAt)
        
    }
}
