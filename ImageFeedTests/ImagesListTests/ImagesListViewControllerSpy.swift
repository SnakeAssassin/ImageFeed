import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListControllerProtocol {

    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    
    func updateTableViewAnimated(indexPath: [IndexPath]) {
        updateTableViewAnimatedCalled = true
    }
}

