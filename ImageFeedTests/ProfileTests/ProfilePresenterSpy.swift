import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var testDidLoadCalled = false
    
    func getImageURL() -> URL? {
        return URL(string: "https://testURL.com/")
    }
    
    func viewDidLoad() {
        testDidLoadCalled = true
    }
    
    func cleanTokenAndCookie() {

    }
}
