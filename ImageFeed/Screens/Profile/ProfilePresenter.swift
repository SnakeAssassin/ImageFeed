import Foundation

// MARK: - ProfilePresenterProtocol

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func getImageURL() -> URL?
    func viewDidLoad()
    func cleanTokenAndCookie()
}

// MARK: - ProfilePresenter

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: Properties
    
    weak var view: ProfileViewControllerProtocol?
    
    var profileService: ProfileServiceProtocol
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    init(profileService: ProfileServiceProtocol){
        self.profileService = profileService
    }
    
    // MARK: Methods
    
    func getImageURL() -> URL? {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
    func viewDidLoad(){
        startObserver()
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
    }
    
    func cleanTokenAndCookie() {
        profileLogoutService.logout()
    }    
    
    private func startObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                view?.updateAvatar()
            }
        view?.updateAvatar()
    }
}
