import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var presenterDidLoadRequestCalled = false
    var testUpdateAvatarCalled = false
    var testUpdateUICalled = false
    
    func updateProfileDetails(profile: Profile) {
        presenterDidLoadRequestCalled = true
    }
    
    func updateAvatar() {
        testUpdateAvatarCalled = true
    }
}
