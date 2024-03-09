@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {

    func testProfileViewCallsViewDidLoad() {
        //Given:
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        _ = viewController.view
        // Then:
        XCTAssertTrue(presenter.testDidLoadCalled)
    }

    func testProfilePresenterCallsViewDidLoad() {
        //Given:
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileServiceSpy()
        let presenter = ProfilePresenter(profileService: profileService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        profileService.profile = Profile(username: "",
                                         name: "",
                                         loginName: "",
                                         bio: "")
        // When:
        presenter.viewDidLoad()
        // Then:
        XCTAssertTrue(viewController.presenterDidLoadRequestCalled)
    }
    
    func testProfileViewUpdateAvatar() {
        // Given:
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileServiceSpy()
        let presenter = ProfilePresenter(profileService: profileService)
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        presenter.viewDidLoad()
        // Then:
        XCTAssertTrue(viewController.testUpdateAvatarCalled)
    }
    
    func testProfileViewGetImageURL() {
        // Given:
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        viewController.updateAvatar()
        // Then:
        XCTAssertEqual(presenter.getImageURL(), URL(string: "https://testURL.com/"))
    }  
}
