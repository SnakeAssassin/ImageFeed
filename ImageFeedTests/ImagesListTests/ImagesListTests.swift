@testable import ImageFeed
import XCTest

final class ImagesListTest: XCTestCase {

// MARK: - Tests Presenter (6)
    
    func testPresenterCallsViewDidLoad() {
        // Given:
        let controller = ImagesListViewController()
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenterSpy(imagesListService: service)
        controller.presenter = presenter
        presenter.view = controller
        // When:
        _ = controller.view
        // Then:
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterGetPhoto() {
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenterSpy(imagesListService: service)
        // When:
        presenter.getPhoto(indexPath: IndexPath(row: 0, section: 0))
        // Then:
        XCTAssertEqual(presenter.photo.id, "testId")
        XCTAssertEqual(presenter.photo.size.width, 100)
        XCTAssertEqual(presenter.photo.size.height, 200)
        XCTAssertEqual(presenter.photo.welcomeDescription, "testBio")
        XCTAssertEqual(presenter.photo.thumbImageURL, "testThumb")
        XCTAssertEqual(presenter.photo.largeImageURL, "testLarge")
        XCTAssertEqual(presenter.photo.isLiked, true)
    }
    
    func testPresenterGetPhotosCount() {
        // Given:
        let controller = ImagesListViewController()
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenterSpy(imagesListService: service)
        controller.presenter = presenter
        presenter.view = controller
        // When:
        controller.tableView(_: UITableView(), numberOfRowsInSection: 0)
        // Then:
        XCTAssertEqual(presenter.photosPhotosCount, 10)
    }
    
    func testPresenterShouldFetchPhotosNextPage() {
        // Given:
        let controller = ImagesListViewController()
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenterSpy(imagesListService: service)
        controller.presenter = presenter
        presenter.view = controller
        // When:
        controller.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 0, section: 0))
        // Then:
        XCTAssertTrue(presenter.shouldFetchPhotosNextPageCalled)
    }
    
    func testPresenterChangeLike() {
        // Given:
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenterSpy(imagesListService: service)
        // When:
        presenter.changeLike(indexPath: IndexPath(row: 0, section: 0)) { _ in }
        // Then:
        XCTAssertTrue(presenter.changeLikeCalled)
    }
    
    func testPresenterGetCellData() {
        // Given:
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenterSpy(imagesListService: service)
        // When:
        presenter.getCellData(indexPath: IndexPath(row: 0, section: 0))
        // Then:
        XCTAssertTrue(presenter.getCellDataCalled)
    }
    
    
    // MARK: - Tests Controller (1)
    
    func testControllerUpdateTableViewAnimated() {
        // Given:
        let controller = ImagesListViewControllerSpy()
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: service)
        controller.presenter = presenter
        presenter.view = controller
        // When:
        controller.updateTableViewAnimated(indexPath: [IndexPath(row: 0, section: 0)])
        // Then:
        XCTAssertTrue(controller.updateTableViewAnimatedCalled)
    }
    
    // MARK: - Tests Service (2)
    
    func testServiceFetchPhotosNextPage() {
        // Given:
        let controller = ImagesListViewController()
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: service)
        controller.presenter = presenter
        presenter.view = controller
        // When:
        presenter.imagesListService.fetchPhotosNextPage()
        // Then:
        XCTAssertTrue(service.fetchPhotosNextPageCalled)
    }
    
    func testServiceChangeLike() {
        // Given:
        let controller = ImagesListViewController()
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: service)
        controller.presenter = presenter
        presenter.view = controller
        // When:
        service.changeLike(photoId: "", isLike: false) { _ in }
        // Then:
        XCTAssertTrue(service.changeLikeCalled)
    }
}
