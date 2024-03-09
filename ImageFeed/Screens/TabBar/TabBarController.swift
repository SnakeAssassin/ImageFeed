import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite

        let imagesListViewController = ImagesListViewController()
        let imagesListService = ImagesListService.shared
        let imagesListPresenter = ImagesListPresenter(imagesListService: imagesListService)
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(named: "tab_editorial_active"),
                                                        selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        let profileService = ProfileService.shared
        let profilePresenter = ProfilePresenter(profileService: profileService)
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
