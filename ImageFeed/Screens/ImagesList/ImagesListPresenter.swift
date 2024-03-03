import Foundation

// MARK: - ImagesListPresenter Protocol

public protocol ImagesListPresenterProtocol {
    var view: ImagesListControllerProtocol? { get set }
    func viewDidLoad()
    func getPhotosCount() -> Int
    func getCellData(indexPath: IndexPath) -> (imageURL: String, isLiked: Bool, createdAt: String)
    func shouldFetchPhotosNextPage(lastImage: Int/*, getOnlyFirstPageIn UITestMode: Bool*/)
    func getPhoto(indexPath: IndexPath) -> Photo
    func changeLike(indexPath: IndexPath, _ completion: @escaping (Result<Bool, Error>) -> ())
}

// MARK: - ImagesList Presenter

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    // MARK: Properties
    
    weak var view: ImagesListControllerProtocol?
    
    //private let imagesListService = ImagesListService.shared
    var imagesListService: ImagesListServiceProtocol
        
    init(imagesListService: ImagesListServiceProtocol){
        self.imagesListService = imagesListService
    }
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    // MARK: Public Methods
    
    func viewDidLoad() {
        startObserver()
        self.imagesListService.fetchPhotosNextPage()
    }
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func getCellData(indexPath: IndexPath) -> (imageURL: String, isLiked: Bool, createdAt: String) {
        let imageURL = photos[indexPath.row].thumbImageURL
        let isLiked = photos[indexPath.row].isLiked
        let createdAt = photos[indexPath.row].createdAt == nil ? "" : dateFormatter.string(from: photos[indexPath.row].createdAt!)
        return (imageURL, isLiked, createdAt)
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo {
        return photos[indexPath.row]
    }
    
    func shouldFetchPhotosNextPage(lastImage: Int/*, getOnlyFirstPageIn UITestMode: Bool*/) {
        if lastImage + 1 == photos.count /*&& !UITestMode*/ {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func changeLike(indexPath: IndexPath, _ completion: @escaping (Result<Bool, Error>) -> ()) {
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) {result in
            switch result {
            case .success(let isLiked):
                self.photos[indexPath.row] = self.imagesListService.photos[indexPath.row]
                completion(.success(isLiked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Private Methods
    
    private func startObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification, 
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            updatePhotos()
        }
    }
    
    func updatePhotos() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            let indexPath = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.updateTableViewAnimated(indexPath: indexPath)
        }
    }
}



