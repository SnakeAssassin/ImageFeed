import UIKit
import ProgressHUD

// MARK: - SplashViewController

final class SplashViewController: UIViewController {
    
    // MARK: Private properties
    
    private let tabBarViewControllerIdentifier = "TabBarViewController"
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let oauth2Service = OAuth2Service.shared
    private let profileService: ProfileServiceProtocol = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo_of_Unsplash")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return image
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLogoImage()
        view.backgroundColor = .ypBlack
        
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            swithToAuthController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Create View
    
    private func setLogoImage() {
        view.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


// MARK: - Prepare for segue

extension SplashViewController {
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            print("[SplashViewController/switchToTabBarController()]: Window Invalid Configuration")
            return
        }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func swithToAuthController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - AuthViewController Delegate

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIBlockingProgressHUD.show()
            }
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(let error):
                print("[SplashViewController/fetchOAuthToken()]: Данные токена не получены - \(error)")
                self.showAlertError()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token)  { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                let username = profile.username
                ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in}
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("[SplashViewController/fetchProfile()]: Данные профиля не получены - \(error)")
                self.showAlertError()
                break
            }
        }
    }
    
    private func showAlertError() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        let vc = self.presentedViewController ?? self
        vc.present(alert, animated: true, completion: nil)
    }
}
