import Foundation

// MARK: - ProfilePresenterProtocol

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    var nameLabel: String? { get set }
    var descriptionLabel: String? { get set }
    var loginLabel: String? { get set }
    
    func getImageURL() -> URL?
    func viewDidLoad()
    func cleanTokenAndCookie()
}

// MARK: - ProfilePresenter

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: Properties
    
    weak var view: ProfileViewControllerProtocol?
    var nameLabel: String?
    var descriptionLabel: String?
    var loginLabel: String?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    // MARK: Methods
    
    func getImageURL() -> URL? {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
    func viewDidLoad() {
        guard let profile = profileService.profile else { return }
        nameLabel = profile.name
        loginLabel = profile.loginName
        descriptionLabel = profile.bio
        view?.updateProfileDetails()
    }
    
    func cleanTokenAndCookie() {
        profileLogoutService.logout()
    }    
}
